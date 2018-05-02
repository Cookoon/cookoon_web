class Service < ApplicationRecord
  belongs_to :reservation

  scope :payment_tied_to_reservation, -> { where(payment_tied_to_reservation: true) }

  delegate :cookoon, :user, to: :reservation

  monetize :price_cents, disable_validation: true
  monetize :payment_amount_cents, disable_validation: true
  monetize :discount_amount_cents

  # can we fin a better name for tied_to_reservation ?
  enum status: %i[quote paid]
  enum category: %i[special catering chef corporate]

  # TODO: SET ACTUAL PRICES
  PRICES = {
    catering: { base_price: 0, unit_price: 100 },
    chef: { base_price: 0, unit_price: 100 },
    corporate: { base_price: 0, unit_price: 100 }
  }.freeze

  def compute_price
    return nil if special?
    prices = PRICES[category.to_sym]
    prices[:base_price] + (prices[:unit_price] * reservation.people_count)
  end

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  def payment_amount_cents
    # price_cents is set if created by admin otherwise we compute it based on category
    price_cents || compute_price
  end
end
