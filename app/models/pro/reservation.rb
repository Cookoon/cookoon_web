module Pro
  class Reservation < ApplicationRecord
    include DatesOverlapScope
    include EndAtSetter

    scope :engaged, -> { where(status: %i[proposed modification_requested accepted]) }

    belongs_to :quote, class_name: 'Pro::Quote', foreign_key: :pro_quote_id, inverse_of: :reservations
    belongs_to :cookoon

    has_many :services,
             class_name: 'Pro::Service', inverse_of: :reservation,
             foreign_key: :pro_reservation_id, dependent: :destroy

    enum status: %i[draft proposed modification_requested accepted cancelled ongoing passed dead]

    delegate :company, to: :quote

    monetize :cookoon_price_cents
    monetize :cookoon_fee_cents
    monetize :cookoon_fee_tax_cents
    monetize :services_price_cents
    monetize :services_fee_cents
    monetize :services_tax_cents
    monetize :price_excluding_tax_cents
    monetize :price_cents

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

    validates :start_at, presence: true
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
    validates :people_count, numericality: { only_integer: true, greater_than: 0 }

    before_save :assign_prices
    after_save :update_quote_status, if: :saved_change_to_status

    private

    def assign_prices
      self.cookoon_price = compute_degressive_cookoon_price
      self.cookoon_fee = compute_cookoon_fee
      self.cookoon_fee_tax = compute_cookoon_fee_tax
      self.services_price = compute_services_price
      self.services_fee = compute_services_fee
      self.services_tax = compute_services_tax
      self.price_excluding_tax = compute_price_excluding_tax
      self.price = compute_price
    end

    def compute_full_cookoon_price
      duration * cookoon.price
    end

    def compute_degressive_cookoon_price
      compute_full_cookoon_price * (DEGRESSION_RATES[duration] || 1)
    end

    def compute_cookoon_fee
      compute_degressive_cookoon_price * DEFAULTS[:fee_rate]
    end

    def compute_cookoon_fee_tax
      compute_cookoon_fee * DEFAULTS[:tax_rate]
    end

    def compute_services_price
      services_price_cents = services.sum(:price_cents)
      Money.new(services_price_cents)
    end

    def compute_services_fee
      compute_services_price * DEFAULTS[:fee_rate]
    end

    def compute_services_tax
      (compute_services_price + compute_services_fee) * DEFAULTS[:tax_rate]
    end

    def compute_price_excluding_tax
      compute_degressive_cookoon_price + compute_cookoon_fee + compute_services_price + compute_services_fee
    end

    def compute_price
      compute_price_excluding_tax + compute_cookoon_fee_tax + compute_services_tax
    end

    def update_quote_status
      quote.confirmed! if accepted?
    end
  end
end
