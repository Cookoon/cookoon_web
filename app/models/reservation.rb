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
  # scope :engaged, -> { accepted.or(ongoing) }
  scope :engaged, -> { charged.or(accepted).or(menu_payment_captured).or(services_payment_captured).or(quotation_asked).or(quotation_proposed).or(quotation_accepted).or(ongoing) }
  # scope :inactive, -> { refused.or(passed) }
  scope :inactive, -> { refused.or(quotation_refused).or(passed).or(cancelled)}
  scope :created_in_day_range_around, ->(datetime) { where created_at: day_range(datetime) }
  scope :in_hour_range_around, ->(datetime) { where start_at: hour_range(datetime) }
  scope :finished_in_day_range_around, ->(datetime) { joins(:inventory).merge(Inventory.checked_out_in_day_range_around(datetime)) }
  scope :created_before, ->(date) { where('created_at < ?', date) }
  scope :pending, -> { initial.or(cookoon_selected).or(menu_selected).or(services_selected) }
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

  monetize :host_payout_price_cents
  monetize :cookoon_price_cents
  monetize :services_price_cents
  monetize :services_tax_cents
  monetize :services_with_tax_cents
  monetize :total_price_cents
  monetize :total_tax_cents
  monetize :total_with_tax_cents

  monetize :butler_price_cents
  monetize :butler_tax_cents
  monetize :butler_with_tax_cents
  monetize :cookoon_butler_price_cents
  monetize :cookoon_butler_tax_cents
  monetize :cookoon_butler_with_tax_cents
  monetize :menu_price_cents
  monetize :menu_tax_cents
  monetize :menu_with_tax_cents


  validates :start_at, presence: true
  validates :start_at, in_future: true, after_notice_period: true, on: :create
  validates :duration, presence: true
  validates :people_count, presence: true, numericality: { greater_than: 0 }
  validates :type_name, inclusion: { in: %w[breakfast brunch lunch diner diner_cocktail lunch_cocktail morning afternoon day], message: "Ce type de réservation n'est pas valide" }
  validates :menu_status, inclusion: { in: %w[initial selected cooking_by_user validated payment_required captured paid], message: "Le statut du menu n'est pas valide" }
  validates :services_status, inclusion: { in: %w[initial validated payment_required captured paid], message: "Le statut n'est pas valide" }
  validates :cookoon_butler_payment_status, inclusion: { in: %w[initial charged captured cancelled paid] }

  validate :tenant_is_not_host

  before_validation :configure_from_type_name, on: :create
  before_save :assign_prices, if: :assign_prices_needed?
  # before_save :assign_prices_for_cookoon_butler_menu, if: :assign_prices_needed_for_cookoon_butler_menu?

  # need to connect this to another condiction
  after_save :report_to_slack, if: :saved_change_to_aasm_state?
  after_save :update_services, if: :services_need_update?

  def pending?
    initial? || cookoon_selected? || menu_selected? || services_selected?
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

  def has_tied_services?
    services.payment_tied_to_reservation.any?
  end

  # def notify_users_after_payment
    # ReservationMailer.paid_request_to_tenant(self).deliver_later
    # ReservationMailer.paid_request_to_host(self).deliver_later
  # end

  def notify_users_after_cookoon_butler_payment
    ReservationMailer.paid_request_cookoon_butler_to_tenant(self).deliver_later
    ReservationMailer.paid_request_cookoon_butler_to_host(self).deliver_later
  end

  def notify_users_after_host_confirmation
    ReservationMailer.paid_confirmation_cookoon_butler_to_tenant(self).deliver_later
    ReservationMailer.paid_confirmation_cookoon_butler_to_host(self).deliver_later
  end

  def notify_users_menu_payment_required
    ReservationMailer.paid_request_menu_to_tenant(self).deliver_later
  end

  def notify_users_services_payment_required
    ReservationMailer.paid_request_services_to_tenant(self).deliver_later
  end

  def notify_users_after_menu_payment
    ReservationMailer.paid_confirmation_menu_to_tenant(self).deliver_later
  end

  def notify_users_after_services_payment
    ReservationMailer.paid_confirmation_services_to_tenant(self).deliver_later
  end

  def admin_close
    payment.transfer
    # ReservationMailer.notify_payout_to_host(self).deliver_later

    close!
    send_ending_surveys
  end

  def butler_count
    # 8 people per butler for business
    # 10 people per butler for customer
    # Magic numbers can be stored in ::DEFAULT
    return 1 unless people_count
    # customer_per_butler = business? ? 9 : 11
    customer_per_butler = business? ? 8 : 10
    # 1 + (people_count / customer_per_butler)
    1 + ((people_count - 1) / customer_per_butler)
  end

  def send_ending_surveys
    # ReservationMailer.ending_survey_to_tenant(self).deliver_later
    # ReservationMailer.ending_survey_to_host(self).deliver_later
  end

  def invoice?
    ongoing? || passed?
  end

  def assign_prices
    # assign_attributes(computed_price_attributes)
    assign_attributes(
      computed_price_attributes.fetch_values(
        :cookoon, :butler, :cookoon_butler, :menu, :services, :total
      ).reduce(:merge)
    )
  end

  # def assign_prices
  #   assign_attributes(computed_price_attributes)
  # end

  # def assign_prices_for_cookoon_butler_menu
  #   assign_attributes(
  #     computed_price_attributes.fetch_values(
  #       :cookoon, :butler, :cookoon_butler, :menu, :total
  #     ).reduce(:merge)
  #   )
  # end

  def host_payout_price_cents
    cookoon_price_cents
  end

  def needs_chef?
    %w[brunch lunch diner diner_cocktail lunch_cocktail afternoon day].include? type_name
  end

  def needs_cookoon_butler_payment?
    cookoon_butler_with_tax > 0 && (cookoon_selected? || menu_selected? || services_selected?) && cookoon_butler_with_tax > 0
  end

  def needs_menu_selection?
    initial? || cookoon_selected? || menu_selected? || services_selected?
  end

  def needs_menu_validation?
    (charged? || accepted? || quotation_asked?) && menu_status == "selected"
  end

  def needs_menu_payment_asking?
    menu_with_tax > 0 && accepted? && menu_status == "validated"
  end

  def needs_menu_payment?
    accepted? && menu_status == "payment_required"
  end

  def needs_services_validation?
    services_status == "initial" && (charged? || accepted? || quotation_asked? || menu_payment_captured?)
  end

  def needs_services_payment_asking?
    services_with_tax > 0 && services_status == "validated" && ((accepted? && menu_status == "cooking_by_user") || menu_payment_captured?)
  end

  def needs_services_payment?
    services_status == "payment_required" && ((accepted? && menu_status == "cooking_by_user") || menu_payment_captured?)
  end

  def accepts_new_service?
    needs_services_validation?
  end

  def seated?
    type_name == 'diner' || type_name == 'lunch' || type_name == 'brunch'
  end

  def standing?
    type_name == 'diner_cocktail' || type_name == 'lunch_cocktail'
  end

  def start_at_for_chef_and_service
    start_at - time_for_preparation
  end

  def end_at_for_chef_and_service
    end_at + time_for_tidying
  end

  def stripe_payment_intent_amount_cookoon_butler
    stripe_payment_intent_amount(stripe_charge_id)
  end

  def stripe_payment_intent_amount_menu
    stripe_payment_intent_amount(stripe_menu_id)
  end

  def stripe_payment_intent_amount_services
    stripe_payment_intent_amount(stripe_services_id)
  end

  private

  def configure_from_type_name
    Reservation::Configurator.new(self).call
  end

  def services_need_update?
    return unless saved_change_to_aasm_state?
    # saved_change_to_aasm_state.last == 'charged'
    saved_change_to_aasm_state.last == 'services_paid'
  end

  def update_services
    services.payment_tied_to_reservation.each(&:paid!)
  end

  def assign_prices_needed?
    cookoon_selected? || menu_selected? || services_selected? || quotation_proposed?
  end

  # def assign_prices_needed_for_cookoon_butler_menu?
  #   cookoon_selected? || menu_selected? || services_selected? || quotation_proposed?
  # end

  def report_to_slack
    return unless Rails.env.production?
    PingSlackReservationJob.perform_later(id) if notification_needed?
  end

  def notification_needed?
    %w(charged quotation_asked accepted refused ongoing passed cancelled).include? aasm_state
  end

  def tenant_is_not_host
    return unless cookoon && user
    errors.add(:cookoon, :host_cannot_be_tenant) if cookoon.user == user
  end

  def total_time_including_preparation_and_tidying_in_seconds
    duration * (60 * 60)
  end

  def total_time_excluding_preparation_and_tidying_in_seconds
    (end_at - start_at)
  end

  def time_for_preparation_and_tidying
    total_time_including_preparation_and_tidying_in_seconds - total_time_excluding_preparation_and_tidying_in_seconds
  end

  def time_for_preparation
    2.fdiv(3) * time_for_preparation_and_tidying
  end

  def time_for_tidying
    1.fdiv(3) * time_for_preparation_and_tidying
  end

  def stripe_payment_intent_amount(stripe_payment_intent)
    Money.new(Stripe::PaymentIntent.retrieve(stripe_payment_intent).amount)
  end
end
