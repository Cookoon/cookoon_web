class Ephemeral < ApplicationRecord
  belongs_to :cookoon

  validates :title, presence: true
  validates :start_at, presence: true
  validates :duration, presence: true
  validates :people_count, presence: true

  monetize :service_price_cents
  monetize :degressive_price_cents, disable_validation: true
  monetize :payment_amount_cents, disable_validation: true

  enum status: %i[inactive available unavailable]

  def base_price_cents
    duration * cookoon.price_cents
  end

  def degressive_price_cents
    degressive_rate = Reservation::DEGRESSION_RATES[duration] || 1
    (base_price_cents * degressive_rate).round
  end

  def tenant_fee_rate
    Reservation::DEFAULTS[:tenant_fee_rate]
  end

  def tenant_fee_cents
    (degressive_price_cents * tenant_fee_rate).round
  end

  def price_with_tenant_fee_cents
    degressive_price_cents + tenant_fee_cents
  end

  def payment_amount_cents
    price_with_tenant_fee_cents + service_price_cents
  end
end
