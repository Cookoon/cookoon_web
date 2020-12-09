class Cookoon < ApplicationRecord
  include Filterable
  include TimeRangeBuilder

  scope :displayable_on_index, -> { joins(:user).where.not(users: { stripe_account_id: nil }) }
  # scope :accomodates_for, ->(people_count) { where('capacity >= ?', people_count) }
  scope :accomodates_for, -> (reservation) {
    if reservation.seated?
      where('capacity >= ?', reservation.people_count)
    elsif reservation.standing?
      where('capacity_standing >= ?', reservation.people_count)
    else
      Cookoon.none
    end
  }
  scope :available_for, ->(user) { where.not(user: user) }
  # scope :available_in, ->(range) { without_reservation_in(range).without_availability_in(range) }
  # scope :without_reservation_in, ->(range) { where.not(id: Reservation.engaged.overlapping(range).pluck(:cookoon_id).uniq) }
  # scope :available_in_day, -> (day) { approved.displayable_on_index.available_in((day.in_time_zone.beginning_of_day + 2.hours)..(day.in_time_zone.end_of_day)) }
  # scope :without_reservation_in, ->(range) { where.not(id: Reservation.engaged.map { |reservation| { cookoon_id: reservation.cookoon_id, start_at_for_chef_and_service: reservation.start_at_for_chef_and_service, end_at_for_chef_and_service: reservation.end_at_for_chef_and_service } }.select { |reservation| (reservation[:start_at_for_chef_and_service] >= range.first && reservation[:start_at_for_chef_and_service] <= range.last) || (reservation[:end_at_for_chef_and_service] >= range.first && reservation[:end_at_for_chef_and_service] <= range.last) }.pluck(:cookoon_id).uniq) }
  # scope :without_availability_in, ->(range) { where.not(id: Availability.unavailable.overlapping(range).pluck(:cookoon_id).uniq) }
  scope :created_in_day_range_around, ->(date_time) { where created_at: day_range(date_time) }
  scope :over_price, ->(price) { where 'price_cents >= ?', price }

  scope :available_in_day, -> (day) { approved.displayable_on_index.without_reservation_in_day(day).without_availability_in_day(day) }
  scope :without_reservation_in_day, ->(day) { where.not(id: Reservation.engaged.where('start_at >= ? AND start_at <= ?', day.beginning_of_day, day.end_of_day).pluck(:cookoon_id).uniq) }
  scope :without_availability_in_day, ->(day) { where.not(id: Availability.unavailable.where(date: day).pluck(:cookoon_id).uniq) }

  scope :unavailable_in_day, -> (day) { (approved.displayable_on_index.with_reservation_in_day(day)).or(approved.displayable_on_index.with_availability_in_day(day)) }
  scope :with_reservation_in_day, ->(day) { where(id: Reservation.engaged.where('start_at >= ? AND start_at <= ?', day.beginning_of_day, day.end_of_day).pluck(:cookoon_id).uniq) }
  scope :with_availability_in_day, ->(day) { where(id: Availability.unavailable.where(date: day).pluck(:cookoon_id).uniq) }

  scope :random, -> { order(Arel::Nodes::NamedFunction.new('RANDOM', [])) }

  # scope :amex, -> { where(id: AMEX_COOKOONS) }
  scope :amex, -> { where(amex: true) }

  # case Rails.env
  # when "staging"
  #   AMEX_COOKOONS = [11, 12, 13, 14]
  # when "production"
  #   AMEX_COOKOONS = [59, 89, 82, 9]
  # when "development"
  #   AMEX_COOKOONS = [Cookoon.first.id, Cookoon.last.id]
  # end

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

  # has_attachments :photos, minimum: 4, maximum: 10, order: 'id ASC'
  has_attachments :photos, order: 'id ASC'
  has_attachment :main_photo
  has_attachment :long_photo

  enum status: %i[under_review approved suspended]
  geocoded_by :address
  monetize :price_cents

  validates :name,     presence: true
  validates :citation, presence: true
  validates :surface,  presence: true, numericality: { greater_than: 0 }
  validates :price,    presence: true, numericality: { greater_than: 0 }
  validates :address,  presence: true
  validates :description, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :capacity_standing, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :photos, presence: true, length: { minimum: 4, maximum: 10, message: "doit comporter au moins 4 éléments et au plus 10" }
  validates :perks,    presence: true
  validates :main_photo, presence: true
  validates :long_photo, presence: true

  validate :count_per_user, on: :create

  # validates_length_of :photos, minimum: 2, maximum: 5, message: "Vous devez télécharger au moins 2 photos et au plus 5 photos"

  after_validation :geocode, if: :address_changed?
  after_update :award_invite_to_user, if: :saved_change_to_status?

  # def unavailabilites(date_range)
  #   overlapping_reservations(date_range) + overlapping_availabilities(date_range)
  # end

  def list_perks
    # cannot pluck because of delegation
    perks.map(&:name).join(' / ')
  end

  def all_photos
    self.photos.shuffle.unshift(self.main_photo, self.long_photo)
  end

  def sample_photos
    self.photos.sample(4)
  end

  private

  # def overlapping_reservations(date_range)
  #   reservations.accepted.overlapping(date_range)
  # end

  # def overlapping_availabilities(date_range)
  #   availabilities.unavailable.overlapping(date_range)
  # end

  def notify_approved
    return unless saved_change_to_status == %w[under_review approved]
    # CookoonMailer.notify_approved(self).deliver_later
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
