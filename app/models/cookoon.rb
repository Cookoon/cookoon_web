class Cookoon < ApplicationRecord
  belongs_to :user
  has_many :reservations

  has_attachments :photos, maximum: 5

  monetize :price_cents

  geocoded_by :address

  validates :name,     presence: true
  validates :surface,  presence: true
  validates :price,    presence: true
  validates :address,  presence: true
  validates :capacity, presence: true
  validates :category, presence: true
  validates :photos, presence: true

  after_validation :geocode, if: :address_changed?

  scope :displayable_on_index, -> { joins(:user).where.not(users: {stripe_account_id: nil}) }

  CATEGORIES = %w(Appartement Maison Jardin Loft Terrasse Toit Villa)
end
