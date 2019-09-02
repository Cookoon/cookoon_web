class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :unit_price_cents
  monetize :price_cents

  enum status: %i[quote paid]
  enum category: %i[special sommelier parking corporate catering breakfast]

  before_create :set_price_cents

  validates :category, presence: true
  validates :category, uniqueness: { scope: :reservation }

  PRICES = {
    special: { base_price: 0, unit_price: 0 },
    sommelier: { base_price: 0, unit_price: 0 },
    parking: { base_price: 0, unit_price: 11000 },
    corporate: { base_price: 0, unit_price: 2500 },
    catering: { base_price: 0, unit_price: 2500 },
    breakfast: { base_price: 0, unit_price: 2500 }
  }.freeze

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  private

  def set_price_cents
    return if sommelier? || special?
    self.price_cents = compute_price
  end

  def compute_price
    prices = PRICES[category.to_sym]
    if parking?
      prices[:base_price] + (prices[:unit_price] * reservation.duration)
    else
      prices[:base_price] + (prices[:unit_price] * reservation.people_count)
    end
  end
end
