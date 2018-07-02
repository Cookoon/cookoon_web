class Cookoon < ApplicationRecord
  include Filterable
  include TimeRangeBuilder

  scope :displayable_on_index, -> { joins(:user).where.not(users: { stripe_account_id: nil }) }
  scope :accomodates_for, ->(people_count) { where('capacity >= ?', people_count) }
  scope :near_default_radius, ->(address) { near(address, Search.default.radius) }
  scope :available_in, ->(range) { without_reservation_in(range).without_availabilty_in(range) }
  scope :without_reservation_in, ->(range) { where.not(id: Reservation.accepted.overlapping(range).pluck(:cookoon_id).uniq) }
  scope :without_availabilty_in, ->(range) { where.not(id: Availability.unavailable.overlapping(range).pluck(:cookoon_id).uniq) }
  scope :created_in_day_range_around, ->(date_time) { where created_at: day_range(date_time) }

  CATEGORIES = %w[Appartement Maison Jardin Loft Terrasse Toit Villa].freeze
  MAX_PER_USER = 2

  belongs_to :user
  has_many :reservations, dependent: :restrict_with_exception
  has_many :availabilities, dependent: :destroy
  has_many :future_availabilities, -> { future }, class_name: 'Availability', inverse_of: :cookoon

  has_attachments :photos, maximum: 5, order: 'id ASC'

  enum status: %i[under_review approved suspended]
  geocoded_by :address
  monetize :price_cents

  validates :name,     presence: true
  validates :surface,  presence: true
  validates :price,    numericality: { greater_than: 0 }
  validates :address,  presence: true
  validates :capacity, presence: true
  validates :category, presence: true
  validates :photos,   presence: true
  validate :count_per_user, on: :create

  after_validation :geocode, if: :address_changed?
  after_create :create_trello_card
  after_save :update_trello, :notify_approved, if: :saved_change_to_status?

  def unavailabilites(date_range)
    overlapping_reservations(date_range) + overlapping_availabilities(date_range)
  end

  private

  def overlapping_reservations(date_range)
    reservations.accepted.overlapping(date_range)
  end

  def overlapping_availabilities(date_range)
    availabilities.unavailable.overlapping(date_range)
  end

  def create_trello_card
    return unless Rails.env.production?
    CreateCookoonTrelloCardJob.perform_later(id)
  end

  def update_trello
    return unless Rails.env.production?
    UpdateCookoonTrelloCardJob.perform_later(id)
  end

  def notify_approved
    return unless saved_change_to_status == %w[under_review approved]
    CookoonMailer.notify_approved(self).deliver_later
  end

  def count_per_user
    unless user.has_less_than_max_cookoons?
      errors.add(:user, :too_many_cookoons)
    end
  end
end
