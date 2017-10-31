class Reservation < ApplicationRecord
  belongs_to :cookoon
  belongs_to :user
  has_one :inventory

  monetize :price_cents

  validates :price_cents, presence: true

  enum status: [ :pending, :paid, :accepted, :refused, :cancelled, :ongoing, :passed ]

  def host_cookoon_fee_rate
    0.05
  end

  def rent_cookoon_fee_rate
    0.07
  end

  def pending_or_paid?
    pending? || paid?
  end

  def price_for_rent
    duration * cookoon.price
  end

  def cookoon_fees
    price_for_rent * rent_cookoon_fee_rate
  end

  def host_cookoon_fees
    price_for_rent * host_cookoon_fee_rate
  end

  def price_for_rent_with_fees
    price_for_rent + cookoon_fees
  end

  def cookoon_owner
    cookoon.user
  end

  def price_for_services
    amount = 0
    amount += base_option_price if janitor
    amount += base_option_price if cleaning
    Money.new amount * 100
  end

  def payout_price_for_host
    price_for_rent - total_fees_with_services_for_host
  end

  def total_fees_with_services_for_host
    host_cookoon_fees + price_for_services
  end

  def starts_soon?
    date.between?(Time.zone.now, (Time.zone.now + 3.hours))
  end

  private

  def base_option_price
    15
  end
end
