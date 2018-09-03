module Pro
  class Reservation < ApplicationRecord
    include DatesOverlapScope
    include EndAtSetter

    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: :pro_quote_id, inverse_of: :reservations
    belongs_to :cookoon

    has_many :services,
             class_name: 'Pro::Service', inverse_of: :reservation,
             foreign_key: :pro_reservation_id, dependent: :destroy

    monetize :cookoon_price_cents
    monetize :cookoon_fee_cents
    monetize :cookoon_fee_tax_cents
    monetize :services_price_cents
    monetize :services_fee_cents
    monetize :services_tax_cents
    monetize :price_excluding_tax_cents
    monetize :price_cents

    enum status: %i[draft proposed modification_requested accepted cancelled ongoing passed dead]

    delegate :company, to: :quote

    scope :engaged, -> {where(status: %i[proposed modification_requested accepted])}

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    before_save :assign_prices
    after_save :update_quote_status, if: :saved_change_to_status

    private

    DEGRESSION_RATES = {
      2 => 1,
      3 => 1,
      4 => 1,
      5 => 0.85,
      6 => 0.85,
      7 => 0.85,
      8 => 0.85,
      9 => 0.85,
      10 => 0.8
    }.freeze

    DEFAULTS = {
      fee_rate: 0.07,
      tax_rate: 0.2
    }.freeze

    def assign_prices
      self.cookoon_price = (duration * cookoon.price) * (DEGRESSION_RATES[duration] || 1)
      self.cookoon_fee = cookoon_price * DEFAULTS[:fee_rate]
      self.cookoon_fee_tax = cookoon_fee * DEFAULTS[:tax_rate]
      self.services_price_cents = services.sum(:price_cents)
      self.services_fee = services_price * DEFAULTS[:fee_rate]
      self.services_tax = (services_price + services_fee) * DEFAULTS[:tax_rate]
      self.price_excluding_tax = cookoon_price + cookoon_fee + services_price + services_fee
      self.price = price_excluding_tax + cookoon_fee_tax + services_tax
    end

    def update_quote_status
      quote.confirmed! if accepted?
    end
  end
end
