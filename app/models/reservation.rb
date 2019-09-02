class Reservation < ApplicationRecord
  include ReservationStateMachine
  include DatesOverlapScope
  include EndAtSetter
  include TimeRangeBuilder
  include PriceComputer

  scope :displayable, -> { where.not(aasm_state: :initial).order(start_at: :asc) }
  scope :for_tenant, ->(user) { where(user: user) }
  scope :for_host, ->(user) { where(cookoon: user.cookoons) }
  scope :active, -> { charged.or(accepted).or(ongoing).or(quotation_asked) }
  scope :engaged, -> { accepted.or(ongoing) }
  scope :inactive, -> { refused.or(passed) }
  scope :created_in_day_range_around, ->(datetime) { where created_at: day_range(datetime) }
  scope :in_hour_range_around, ->(datetime) { where start_at: hour_range(datetime) }
  scope :finished_in_day_range_around, ->(datetime) { joins(:inventory).merge(Inventory.checked_out_in_day_range_around(datetime)) }
  scope :created_before, ->(date) { where('created_at < ?', date) }
  scope :pending, -> { initial.or(cookoon_selected).or(services_selected) }
  scope :dropped_before_payment, -> { pending.created_before(DEFAULTS[:safety_period].ago) }
  scope :paid, -> { where(paid: true) }
  scope :short_notice, -> { paid.where('start_at < ?', Time.zone.now.in(DEFAULTS[:safety_period])) }
  scope :stripe_will_not_capture, -> { paid.created_before(DEFAULTS[:stripe_validity_period].ago.in(DEFAULTS[:safety_period])) }

  belongs_to :user
  belongs_to :cookoon, optional: true
  belongs_to :menu, optional: true
  has_many :services, dependent: :destroy
  has_one :inventory, dependent: :destroy

  accepts_nested_attributes_for :services

  enum category: %i[customer business]

  DEFAULTS = {
    stripe_validity_period: 7.days,
    safety_period: 2.hours,
    fee_rate: 0.07,
    tax_rate: 0.2
  }.freeze

  monetize :cookoon_price_cents
  monetize :services_price_cents
  monetize :services_tax_cents
  monetize :services_with_tax_cents
  monetize :total_price_cents
  monetize :total_tax_cents
  monetize :total_with_tax_cents

  validates :start_at, presence: true
  validates :duration, presence: true
  validates :people_count, presence: true
  validates :start_at, in_future: true, after_notice_period: true, on: :create
  validates :type_name, inclusion: { in: %w[breakfast brunch lunch diner cocktail morning afternoon day], message: "Ce type de réservation n'est pas valide" } 

  validate :tenant_is_not_host

  before_validation :configure_from_type_name, on: :create
  before_save :assign_prices, if: :assign_prices_needed?
  
  # need to connect this to another condiction
  # after_save :report_to_slack, if: :saved_change_to_status?
  #after_save :update_services, if: :services_need_update?

  def invoiceable?
    accepted? || ongoing? || passed?
  end

  def cookoon_owner
    cookoon.user
  end

  def pending_or_paid?
    initial? || paid
  end

  def refused_passed_or_cancelled?
    refused? || passed? #|| cancelled? Uncomment when implementing cancel
  end

  def payment(options = {})
    @payment ||= Reservation::Payment.new(self, options)
  end

  def starts_soon?
    start_at.past? || start_at.between?(Time.zone.now, (Time.zone.now + 3.hours))
  end

  def has_tied_services?
    services.payment_tied_to_reservation.any?
  end

  def notify_users_after_payment
    ReservationMailer.paid_request_to_tenant(self).deliver_later
    ReservationMailer.paid_request_to_host(self).deliver_later
  end

  def notify_users_after_confirmation
    ReservationMailer.confirmed_to_tenant(self).deliver_later
    ReservationMailer.confirmed_to_host(self).deliver_later
  end

  def admin_close
    payment.transfer
    ReservationMailer.notify_payout_to_host(self).deliver_later

    close!
    send_ending_surveys
  end

  def butler_count
    # 10 people per butler for business
    # 8 people per butler for customer
    # Magic numbers can be stored in ::DEFAULT
    return 1 unless people_count
    customer_per_butler = business? ? 9 : 11
    1 + (people_count / customer_per_butler)
  end

  def send_ending_surveys
    ReservationMailer.ending_survey_to_tenant(self).deliver_later
    ReservationMailer.ending_survey_to_host(self).deliver_later
  end

  def invoice?
    ongoing? || passed?
  end

  def assign_prices
    assign_attributes(computed_price_attributes)
  end
  
  def host_fee_rate
    DEFAULTS[:fee_rate]
  end

  def host_fee_cents
    (cookoon_price_cents * host_fee_rate).round
  end

  def host_payout_price_cents
    cookoon_price_cents
  end

  def needs_chef?
    %w[brunch lunch diner cocktail afternoon day].include? type_name
  end

  private

  # Move this elsewhere
  def configure_from_type_name
    return unless type_name.present? && start_at.present?
    case type_name
    when 'breakfast'
      self.duration = 3
      self.start_at = start_at.change(hour: 8, min: 30)
      services.build(category: :breakfast, payment_tied_to_reservation: true)
    when 'brunch'
      self.duration = 4
      self.start_at = start_at.change(hour: 12, min: 30)
    when 'lunch'
      self.duration = 5
      self.start_at = start_at.change(hour: 12, min: 30)
    when 'diner'
      self.duration = 7
      self.start_at = start_at.change(hour: 20, min: 0)
    when 'cocktail'
      self.duration = 7
      self.start_at = start_at.change(hour: 19, min: 30)
    when 'morning'
      self.duration = 5
      self.start_at = start_at.change(hour: 9, min: 0)
    when 'afternoon'
      self.duration = 6
      self.start_at = start_at.change(hour: 14, min: 0)
    when 'day'
      self.duration = 11
      self.start_at = start_at.change(hour: 9, min: 0)
    end
  end

  def price_cents_needs_update?
    will_save_change_to_duration? || will_save_change_to_cookoon_id?
  end

  def services_need_update?
    return unless saved_change_to_status?
    saved_change_to_status.last == 'paid'
  end

  def update_services
    services.payment_tied_to_reservation.each(&:paid!)
  end

  def assign_prices_needed?
    cookoon_selected? || menu_selected? || services_selected? || quotation_proposed?
  end

  def report_to_slack
    return unless Rails.env.production?
    PingSlackReservationJob.perform_later(id) if notification_needed?
  end

  def notification_needed?
    %w(paid accepted refused ongoing passed cancelled).include? status
  end

  def tenant_is_not_host
    return unless cookoon && user
    errors.add(:cookoon, :host_cannot_be_tenant) if cookoon.user == user
  end
end
