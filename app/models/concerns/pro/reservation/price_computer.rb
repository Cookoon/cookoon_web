module Pro
  class Reservation
    module PriceComputer
      extend ActiveSupport::Concern

      private

      def degression_rates
        self.class::DEGRESSION_RATES
      end

      def defaults
        self.class::DEFAULTS
      end

      def computed_price_attributes
        {
          cookoon_price: compute_degressive_cookoon_price,
          cookoon_fee: compute_cookoon_fee,
          cookoon_fee_tax: compute_cookoon_fee_tax,
          services_price: compute_services_price,
          services_fee: compute_services_fee,
          services_tax: compute_services_tax,
          price_excluding_tax: compute_price_excluding_tax,
          price: compute_price
        }
      end

      def compute_full_cookoon_price
        duration * cookoon.price
      end

      def compute_degressive_cookoon_price
        compute_full_cookoon_price * (degression_rates[duration] || 1)
      end

      def compute_cookoon_fee
        compute_degressive_cookoon_price * defaults[:fee_rate]
      end

      def compute_cookoon_fee_tax
        compute_cookoon_fee * defaults[:tax_rate]
      end

      def compute_services_price
        services_price_cents = services.sum(:price_cents)
        Money.new(services_price_cents)
      end

      def compute_services_fee
        compute_services_price * defaults[:fee_rate]
      end

      def compute_services_tax
        (compute_services_price + compute_services_fee) * defaults[:tax_rate]
      end

      def compute_price_excluding_tax
        compute_degressive_cookoon_price + compute_cookoon_fee + compute_services_price + compute_services_fee
      end

      def compute_price
        compute_price_excluding_tax + compute_cookoon_fee_tax + compute_services_tax
      end
    end
  end
end
