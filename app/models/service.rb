class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :price_cents, disable_validation: true

  enum status: %i[quote paid]
  enum category: %i[sommelier parking corporate catering breakfast]

  before_create :set_price_cents

  validates :category, presence: true
  validates :category, uniqueness: { scope: :reservation }

  PRICES = {
    sommelier: { base_price: 0, unit_price: 0 },
    parking: { base_price: 0, unit_price: 11000 },
    corporate: { base_price: 2000, unit_price: 1000 },
    catering: { base_price: 0, unit_price: 2500 },
    breakfast: { base_price: 0, unit_price: 2500 }
  }.freeze

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  private

  def set_price_cents
    return if special?
    self.price_cents = compute_price
  end

  def compute_price
    prices = PRICES[category.to_sym]
    prices[:base_price] + (prices[:unit_price] * reservation.people_count)
  end
end
