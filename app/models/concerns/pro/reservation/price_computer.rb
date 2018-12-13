module Pro
  class Reservation
    module PriceComputer
      extend ActiveSupport::Concern

      def computed_price_attributes
        {
          cookoon_price: compute_degressive_cookoon_price,
          cookoon_fee: compute_cookoon_fee_including_tax,
          cookoon_fee_tax: compute_cookoon_fee_tax,
          services_price_without_tax_and_fee: compute_services_price_without_tax_and_fee,
          services_fee: compute_services_fee,
          services_tax: compute_services_tax,
          services_price_with_fee: compute_services_price_with_fee,
          services_price_full: compute_services_price_full,
          price_excluding_tax: compute_price_excluding_tax,
          tax_total: compute_tax_total,
          price: compute_price
        }
      end

      private

      def degression_rates
        self.class::DEGRESSION_RATES
      end

      def defaults
        self.class::DEFAULTS
      end

      def compute_full_cookoon_price
        duration * cookoon.price
      end

      def compute_degressive_cookoon_price
        degression_rate = degression_rates[duration] || 1
        compute_full_cookoon_price * degression_rate
      end

      def compute_cookoon_fee_minus_tax
        compute_degressive_cookoon_price * defaults[:fee_rate] / (1 + defaults[:tax_rate])
      end

      def compute_cookoon_fee_including_tax
        compute_degressive_cookoon_price * defaults[:fee_rate]
      end

      def compute_cookoon_fee_tax
        compute_cookoon_fee_minus_tax * defaults[:tax_rate]
      end

      def compute_services_price_without_tax_and_fee
        services_price_cents = services.sum(:price_cents)
        Money.new(services_price_cents)
      end

      def compute_services_fee
        compute_services_price_without_tax_and_fee * defaults[:fee_rate]
      end

      def compute_services_price_with_fee
        compute_services_price_without_tax_and_fee + compute_services_fee
      end

      def compute_services_tax
        (compute_services_price_without_tax_and_fee + compute_services_fee) * defaults[:tax_rate]
      end

      def compute_services_price_full
        [compute_services_price_without_tax_and_fee, compute_services_fee, compute_services_tax].sum
      end

      def compute_price_excluding_tax
        [compute_degressive_cookoon_price, compute_cookoon_fee_minus_tax, compute_services_price_without_tax_and_fee, compute_services_fee].sum
      end

      def compute_price
        [compute_price_excluding_tax, compute_cookoon_fee_tax, compute_services_tax].sum
      end

      def compute_tax_total
        [compute_services_tax, compute_cookoon_fee_tax].sum
      end
    end
  end
end
