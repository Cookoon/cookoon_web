class Cookoon < ApplicationRecord
  include TimeRange

  scope :displayable_on_index, -> { joins(:user).where.not(users: { stripe_account_id: nil }) }
  scope :created_in_day_range_around, ->(date_time) { where created_at: day_range(date_time) }
  scope :capacity_greater_than, ->(number) { where("capacity >= ?", number) }

  CATEGORIES = %w[Appartement Maison Jardin Loft Terrasse Toit Villa].freeze

  belongs_to :user
  has_many :reservations, dependent: :restrict_with_exception
  has_many :availabilities, dependent: :destroy

  has_attachments :photos, maximum: 5, order: 'id ASC'

  enum status: %i[under_review approved suspended]
  geocoded_by :address
  monetize :price_cents

  validates :name,     presence: true
  validates :surface,  presence: true
  validates :price,    presence: true
  validates :address,  presence: true
  validates :capacity, presence: true
  validates :category, presence: true
  validates :photos,   presence: true

  after_validation :geocode, if: :address_changed?
  after_create :create_trello_card
  after_save :update_trello, :notify_approved, if: :saved_change_to_status?

  private

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
end
