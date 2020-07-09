class Cookoon < ApplicationRecord
  include Filterable
  include TimeRangeBuilder

  scope :displayable_on_index, -> { joins(:user).where.not(users: { stripe_account_id: nil }) }
  scope :accomodates_for, ->(people_count) { where('capacity >= ?', people_count) }
  scope :available_for, ->(user) { where.not(user: user) }
  scope :available_in, ->(range) { without_reservation_in(range).without_availabilty_in(range) }
  scope :without_reservation_in, ->(range) { where.not(id: Reservation.engaged.overlapping(range).pluck(:cookoon_id).uniq) }
  scope :without_availabilty_in, ->(range) { where.not(id: Availability.unavailable.overlapping(range).pluck(:cookoon_id).uniq) }
  scope :created_in_day_range_around, ->(date_time) { where created_at: day_range(date_time) }
  scope :over_price, ->(price) { where 'price_cents >= ?', price }

  scope :random, -> { order(Arel::Nodes::NamedFunction.new('RANDOM', [])) }

  CATEGORIES = %w[Appartement Maison Jardin Loft Terrasse Toit Villa].freeze
  MAX_PER_USER = 2
  REWARD_INVITATIONS_COUNT = 5
  HIGHLIGHT_PRICE_CENTS = 6000

  belongs_to :user
  has_many :reservations, dependent: :restrict_with_exception
  has_many :availabilities, dependent: :destroy
  has_many :future_availabilities, -> { future }, class_name: 'Availability', inverse_of: :cookoon
  has_many :perks, dependent: :destroy
  has_many :perk_specifications, through: :perks

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
  validates :perks,    presence: true

  validate :count_per_user, on: :create

  validates_length_of :photos, minimum: 2, maximum: 5, message: "Vous devez télécharger au moins 2 photos et au plus 5 photos"

  after_validation :geocode, if: :address_changed?
  after_update :award_invite_to_user, if: :saved_change_to_status?

  def unavailabilites(date_range)
    overlapping_reservations(date_range) + overlapping_availabilities(date_range)
  end

  def list_perks
    # cannot pluck because of delegation
    perks.map(&:name).join(' / ')
  end

  private

  def overlapping_reservations(date_range)
    reservations.accepted.overlapping(date_range)
  end

  def overlapping_availabilities(date_range)
    availabilities.unavailable.overlapping(date_range)
  end

  def notify_approved
    return unless saved_change_to_status == %w[under_review approved]
    CookoonMailer.notify_approved(self).deliver_later
  end

  def count_per_user
    if user&.reached_max_cookoons_count?
      errors.add(:user, :max_cookoons_count)
    end
  end

  def award_invite_to_user
    if approved?
      user.invitation_limit += REWARD_INVITATIONS_COUNT
      user.save
    end
  end
end
