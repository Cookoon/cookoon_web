class Reservation < ApplicationRecord
  include ReservationStateMachine
  include DatesOverlapScope
  include EndAtSetter
  include TimeRangeBuilder
  include PriceComputer

  scope :displayable, -> { where.not(aasm_state: :initial).order(start_at: :asc) }
  scope :for_tenant, ->(user) { where(user: user) }
  scope :for_host, ->(user) { where(cookoon: user.cookoons) }
  scope :active, -> { charged.or(accepted).or(ongoing) }
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
  has_many :services, dependent: :destroy
  has_one :inventory, dependent: :destroy

  accepts_nested_attributes_for :services

  # Status will be removed before merged, need to cast production statuses to AASM State before deleting column
  # enum status: %i[pending paid accepted refused cancelled ongoing passed dead]
  
  enum category: %i[customer business]

  DEFAULTS = {
    tenant_fee_rate: 0.07,
    host_fee_rate: 0.07,
    service_price_cents: 2000,
    max_duration: 12,
    max_people_count: 20,
    stripe_validity_period: 7.days,
    safety_period: 2.hours,
    fee_rate: 0.07,
    tax_rate: 0.2
  }.freeze

  DEGRESSION_RATES = {}.freeze # Remove ?

  # Previous values
  # DEGRESSION_RATES = {
  #   2 => 1,
  #   3 => 1,
  #   4 => 1,
  #   5 => 0.85,
  #   6 => 0.85,
  #   7 => 0.85,
  #   8 => 0.85,
  #   9 => 0.85,
  #   10 => 0.8
  # }.freeze

  # ============ THESE NEED TO BE REMOVED WITH NEW DESIGN MERGE ========
  monetize :base_price_cents
  monetize :degressive_price_cents
  monetize :tenant_fee_cents
  monetize :price_with_tenant_fee_cents
  monetize :host_fee_cents
  monetize :default_service_price_cents
  monetize :host_services_price_cents
  monetize :payment_amount_cents
  # ======================================================================

  monetize :cookoon_price_cents
  monetize :cookoon_fee_cents
  monetize :cookoon_fee_tax_cents
  monetize :services_price_cents
  monetize :services_tax_cents
  monetize :services_full_price_cents
  monetize :total_price_cents
  monetize :total_tax_cents
  monetize :total_full_price_cents

  monetize :host_payout_price_cents

  validates :start_at, presence: true
  validates :duration, presence: true
  validates :people_count, presence: true
  validates :start_at, in_future: true, after_notice_period: true, on: :create
  validates :type_name, inclusion: { in: %w[breakfast brunch lunch diner cocktail morning afternoon day], message: "Ce type de réservation n'est pas valide" } 

  validate :tenant_is_not_host

  before_validation :configure_from_type_name, on: :create
  before_save :assign_prices, if: :assign_prices_needed?
  after_save :report_to_slack, if: :saved_change_to_status?
  after_save :update_services, if: :services_need_update?

  def self.default
    OpenStruct.new DEFAULTS.slice(:max_duration, :max_people_count)
  end

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

  def host_services?
    janitor || cleaning
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

    passed!
    send_ending_surveys
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
  
  # To Remove 
  # ======= ICAL ======== 
  def ical_for(role)
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new start_at, tzid: start_at.zone
      e.dtend = Icalendar::Values::DateTime.new end_at, tzid: end_at.zone
      e.summary = ical_params.dig(role, :summary)
      e.location = cookoon.address
      e.description = <<~DESCRIPTION
        #{ical_params.dig(role, :description)}

        Une question ? Rendez-vous sur https://aide.cookoon.fr
      DESCRIPTION
      e.organizer = "mailto:#{Rails.configuration.action_mailer.default_options[:from]}"
    end
    cal
  end

  def ical_file_name
    "#{cookoon.name.parameterize(separator: '_')}_#{start_at.strftime('%d%b%y').downcase}.ics"
  end

  def ical_params
    {
      host: {
        summary: "Location de votre Cookoon : #{cookoon.name}",
        description: <<~DESCRIPTION
          Location de votre Cookoon : #{cookoon.name}

          Locataire :
          #{user.full_name}
          #{user.phone_number} - #{user.email}
        DESCRIPTION
      },
      tenant: {
        summary: "Réservation Cookoon : #{cookoon.name}",
        description: <<~DESCRIPTION
          Réservation Cookoon : #{cookoon.name}

          Hôte :
          #{cookoon.user.full_name}
          #{cookoon.user.phone_number} - #{cookoon.user.email}
        DESCRIPTION
      }
    }
  end
  # =====================

  # Whole prices can be removed since we are reading them from DB
  # ======= PRICES ========
  def default_service_price_cents
    DEFAULTS[:service_price_cents]
  end

  def host_services_price_cents
    [janitor, cleaning].count(true) * default_service_price_cents
  end

  def payment_amount_cents
    price_with_tenant_fee_cents + services_price_cents
  end

  def services_price_cents
    services.payment_tied_to_reservation.sum(:price_cents)
  end

  def tenant_fee_rate
    DEFAULTS[:tenant_fee_rate]
  end

  def tenant_fee_cents
    (degressive_price_cents * tenant_fee_rate).round
  end

  def price_with_tenant_fee_cents
    degressive_price_cents + tenant_fee_cents
  end

  def host_fee_rate
    DEFAULTS[:host_fee_rate]
  end

  def host_fee_cents
    (degressive_price_cents * host_fee_rate).round
  end

  def host_payout_price_cents
    degressive_price_cents - host_fee_cents - host_services_price_cents
  end

  def base_price_cents
    return 0 unless duration && cookoon
    duration * cookoon.price_cents
  end

  def degressive_price_cents
    degressive_rate = DEGRESSION_RATES[duration] || 1
    (base_price_cents * degressive_rate).round
  end

  # ======================

  private

  # Move this elsewhere
  def configure_from_type_name
    return unless type_name.present? && start_at.present?
    case type_name
    when 'breakfast'
      self.duration = 3
      self.start_at = start_at.change(hour: 8, min: 30)
      services.build(category: :catering, payment_tied_to_reservation: true)
    when 'brunch'
      self.duration = 4
      self.start_at = start_at.change(hour: 12, min: 30)
      services.build(category: :catering, payment_tied_to_reservation: true)
    when 'lunch'
      self.duration = 5
      self.start_at = start_at.change(hour: 12, min: 30)
      services.build(category: :chef, payment_tied_to_reservation: true)
    when 'diner'
      self.duration = 7
      self.start_at = start_at.change(hour: 20, min: 0)
      services.build(category: :chef, payment_tied_to_reservation: true)
    when 'cocktail'
      self.duration = 7
      self.start_at = start_at.change(hour: 19, min: 30)
      services.build(category: :catering, payment_tied_to_reservation: true)
    when 'morning'
      self.duration = 5
      self.start_at = start_at.change(hour: 9, min: 0)
      services.build(category: :corporate, payment_tied_to_reservation: true)
    when 'afternoon'
      self.duration = 6
      self.start_at = start_at.change(hour: 14, min: 0)
      services.build(category: :corporate, payment_tied_to_reservation: true)
    when 'day'
      self.duration = 11
      self.start_at = start_at.change(hour: 9, min: 0)
      services.build(category: :chef, payment_tied_to_reservation: true)
      services.build(category: :corporate, payment_tied_to_reservation: true)
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
    services_selected? || quotation_proposed?
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

  # TO REMOVE WHEN DONE
  def possible_in_datetime_range
    return unless start_at && duration
    range = start_at..(start_at + duration.hours)
    errors.add(:cookoon, :unavailable_in_datetime_range) if cookoon.unavailabilites(range).any?
  end
end
