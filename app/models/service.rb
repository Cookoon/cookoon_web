class Service < ApplicationRecord
  belongs_to :reservation

  delegate :cookoon, :user, to: :reservation

  monetize :price_cents
  monetize :discount_amount_cents
  monetize :payment_amount_cents

  enum status: %i[quote paid]

  validates :content, presence: true

  def payment(options = {})
    Service::Payment.new(self, options)
  end

  def payment_amount_cents
    price_cents
  end
end
