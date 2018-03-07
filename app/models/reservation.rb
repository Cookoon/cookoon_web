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

  belongs_to :cookoon
  belongs_to :user
  has_one :inventory, dependent: :destroy
  has_many :reservation_guests, dependent: :destroy
  has_many :guests, through: :reservation_guests

  monetize :price_cents
  monetize :price_for_rent_cents
  monetize :cookoon_fees_cents
  monetize :host_cookoon_fees_cents
  monetize :price_with_fees_cents
  monetize :price_for_services_cents
  monetize :payout_price_cents
  monetize :charge_amount_cents
  monetize :discount_amount_cents
  monetize :total_fees_with_services_for_host_cents
  monetize :base_option_price_cents

  enum status: %i[pending paid accepted refused cancelled ongoing passed]

  validates :start_at, presence: true
  validates :duration, presence: true
  validates :price_cents, presence: true
  validate :available_on_dates, on: :create
  validate :start_after_decent_time, on: :create
  validate :not_my_cookoon

  after_create :create_trello_card
  after_save :update_trello, if: :saved_change_to_status?

  def host_cookoon_fee_rate
    0.07
  end

  def rent_cookoon_fee_rate
    0.05
  end

  def pending_or_paid?
    pending? || paid?
  end

  def services?
    janitor || cleaning
  end

  def price_for_rent_cents
    duration * cookoon.price_cents
  end

  def cookoon_fees_cents
    (price_for_rent_cents * rent_cookoon_fee_rate).round
  end

  def host_cookoon_fees_cents
    (price_for_rent_cents * host_cookoon_fee_rate).round
  end

  def price_with_fees_cents
    price_for_rent_cents + cookoon_fees_cents
  end

  def cookoon_owner
    cookoon.user
  end

  def discount_used?
    discount_amount_cents&.positive?
  end

  def refund_discount_to_user
    return unless discount_used?
    user.discount_balance_cents += discount_amount_cents
    user.save
  end

  def price_for_services_cents
    amount_cents = 0
    amount_cents += base_option_price_cents if janitor
    amount_cents += base_option_price_cents if cleaning
    amount_cents
  end

  def payout_price_cents
    price_for_rent_cents - total_fees_with_services_for_host_cents
  end

  def charge_amount_cents
    price_with_fees_cents - discount_amount_cents
  end

  def total_fees_with_services_for_host_cents
    host_cookoon_fees_cents + price_for_services_cents
  end

  def starts_soon?
    start_at.past? || start_at.between?(Time.zone.now, (Time.zone.now + 3.hours))
  end

  def base_option_price_cents
    2000
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
      },
      guest: {
        summary: "#{user.full_name} via Cookoon",
        description: <<~DESCRIPTION
          Vous avez été invité à un événement Cookoon par

          #{user.full_name}
          #{user.phone_number} - #{user.email}
        DESCRIPTION
      }
    }
  end

  def update_trello
    return unless Rails.env.production?
    UpdateReservationTrelloCardJob.perform_later(id)
  end

  def create_trello_card
    return unless Rails.env.production?
    CreateReservationTrelloCardJob.perform_later(id)
  end

  def start_after_decent_time
    return unless start_at
    errors.add(:start_at, :not_after_decent_time) if start_at < (Time.zone.now + 10.hours)
  end

  def not_my_cookoon
    return unless cookoon && user
    errors.add(:cookoon, :cannot_book_mine) if cookoon.user == user
  end

  def available_on_dates
    range = start_at..(start_at + duration.hours)
    errors.add(:cookoon, :unavailable_on_dates) if cookoon.unavailabilites(range).any?
  end
end
