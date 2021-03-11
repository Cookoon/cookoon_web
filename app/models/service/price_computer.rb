class Service
  module PriceComputer
    extend ActiveSupport::Concern

    def price_with_tax
      price_with_tax_cents / 100
    end

    def price_with_tax_cents
      (price_with_tax_cents_without_rounding / 5).ceil(-2) * 5
    end

    private

    def compute_price
      assign_attributes(price_cents: price_with_tax_cents / (1 + Reservation::TAX))
    end

    def price_with_tax_cents_without_rounding
      (1 + Reservation::TAX) * (1 + margin) * ((quantity_base * base_price_cents) + (quantity * unit_price_cents))
    end
  end
end
