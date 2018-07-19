class Reservation < ApplicationRecord
  include DatesOverlapScope
  include EndAtSetter
  include TimeRangeBuilder

  scope :displayable, -> { where.not(status: :pending).order(start_at: :asc) }
  scope :for_tenant, ->(user) { where(user: user) }
  scope :for_host, ->(user) { where(cookoon: user.cookoons) }
  scope :active, -> { where(status: %i[paid accepted ongoing]) }
  scope :inactive, -> { where(status: %i[refused cancelled passed]) }
  scope :created_in_day_range_around, ->(datetime) { where created_at: day_range(datetime) }
  scope :in_hour_range_around, ->(datetime) { where start_at: hour_range(datetime) }
  scope :finished_in_day_range_around, ->(datetime) { joins(:inventory).merge(Inventory.checked_out_in_day_range_around(datetime)) }
  scope :created_before, ->(date) { where('created_at < ?', date) }
  scope :dropped_before_payment, -> { pending.created_before(DEFAULTS[:safety_period].ago) }
  scope :short_notice, -> { paid.where('start_at < ?', Time.zone.now.in(DEFAULTS[:safety_period])) }
  scope :stripe_will_not_capture, -> { paid.created_before(DEFAULTS[:stripe_validity_period].ago.in(DEFAULTS[:safety_period])) }

  DEFAULTS = {
    tenant_fee_rate: 0.07,
    host_fee_rate: 0.07,
    service_price_cents: 2000,
    max_duration: 12,
    max_people_count: 20,
    stripe_validity_period: 7.days,
    safety_period: 2.hours
  }.freeze

  DEGRESSION_RATES = {
    2 => 1,
    3 => 1,
    4 => 1,
    5 => 0.85,
    6 => 0.85,
    7 => 0.85,
    8 => 0.85,
    9 => 0.85,
    10 => 0.8
  }.freeze

  belongs_to :cookoon
  belongs_to :user
  has_many :services, dependent: :destroy
  has_one :inventory, dependent: :destroy
  has_many :reservation_guests, dependent: :destroy
  has_many :guests, through: :reservation_guests

  accepts_nested_attributes_for :services

  monetize :price_cents
  monetize :discount_amount_cents

  monetize :base_price_cents
  monetize :degressive_price_cents
  monetize :tenant_fee_cents
  monetize :price_with_tenant_fee_cents
  monetize :host_fee_cents
  monetize :default_service_price_cents
  monetize :host_services_price_cents
  monetize :host_payout_price_cents
  monetize :payment_amount_cents
  monetize :services_price_cents

  enum status: %i[pending paid accepted refused cancelled ongoing passed dead]

  validates :start_at, presence: true
  validates :duration, presence: true
  validate :tenant_is_not_host
  validates :start_at, after_notice_period: true, on: :create
  validate :possible_in_datetime_range, on: :create

  before_validation :set_price_cents, if: :price_cents_needs_update?
  after_save :report_to_slack, if: :saved_change_to_status?
  after_save :update_services, if: :services_need_update?

  def self.default
    OpenStruct.new DEFAULTS.slice(:max_duration, :max_people_count)
  end

  def invoiceable?
    accepted? || cancelled? || ongoing? || passed?
  end

  def cookoon_owner
    cookoon.user
  end

  def pending_or_paid?
    pending? || paid?
  end

  def refused_passed_or_cancelled?
    refused? || passed? || cancelled?
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

  def base_price_cents
    return 0 unless duration && cookoon
    duration * cookoon.price_cents
  end

  def degressive_price_cents
    degressive_rate = DEGRESSION_RATES[duration] || 1
    (base_price_cents * degressive_rate).round
  end

  def has_tied_services?
    services.payment_tied_to_reservation.any?
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

  def notify_users_after_payment
    ReservationMailer.paid_request_to_tenant(self).deliver_later
    ReservationMailer.paid_request_to_host(self).deliver_later
  end

  def notify_users_after_confirmation
    ReservationMailer.confirmed_to_tenant(self).deliver_later
    ReservationMailer.confirmed_to_host(self).deliver_later
  end

  def default_service_price_cents
    DEFAULTS[:service_price_cents]
  end

  def host_services_price_cents
    [janitor, cleaning].count(true) * default_service_price_cents
  end

  def host_payout_price_cents
    degressive_price_cents - host_fee_cents - host_services_price_cents
  end

  def payment_amount_cents
    price_with_tenant_fee_cents + services_price_cents
  end

  def admin_close
    payment.transfer
    ReservationMailer.notify_payout_to_host(self).deliver_later

    passed!
    send_ending_surveys
  end

  def full_discount?
    discount_amount_cents >= payment_amount_cents
  end

  def send_ending_surveys
    ReservationMailer.ending_survey_to_tenant(self).deliver_later
    ReservationMailer.ending_survey_to_host(self).deliver_later
  end

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

  private

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

  def set_price_cents
    self.price_cents = degressive_price_cents
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

  def possible_in_datetime_range
    return unless start_at && duration
    range = start_at..(start_at + duration.hours)
    errors.add(:cookoon, :unavailable_in_datetime_range) if cookoon.unavailabilites(range).any?
  end
end
