class Service < ApplicationRecord
  belongs_to :reservation

  monetize :price_cents
  monetize :discount_amount_cents
  monetize :charge_amount_cents

  enum status: %i[quote paid]

  validates :content, presence: true

  def discount_used?
    discount_amount_cents.positive?
  end

  def charge_amount_cents
    price_cents - discount_amount_cents
  end
end
