class Ephemeral < ApplicationRecord
  belongs_to :cookoon

  validates :title, presence: true
  validates :start_at, presence: true
  validates :duration, presence: true
  validates :people_count, presence: true
  # TODO : CP 9may2018 should we monetize this instead ?
  validates :service_price_cents, presence: true

  monetize :service_price_cents
  monetize :price_cents
  monetize :rental_price_cents
  monetize :payment_amount_cents

  enum status: %i[inactive available unavailable]

  def payment(options = {})
    Ephemeral::Payment.new(self, options)
  end

  # TODO CP 9may2018 Refacto?
  def price_cents
    rental_price_cents + service_price_cents
  end

  def rental_price_cents
    cookoon.price_cents * duration
  end

  def payment_amount_cents
    price_cents + ((rental_price_cents * Reservation::DEFAULTS[:tenant_fee_rate]).round)
  end
end
