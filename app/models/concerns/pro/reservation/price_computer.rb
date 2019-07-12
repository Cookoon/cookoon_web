module Pro
  class Reservation
    module PriceComputer
      extend ActiveSupport::Concern

      def computed_price_attributes
        {
          cookoon_price: compute_degressive_cookoon_price,
          cookoon_fee: compute_cookoon_fee,
          cookoon_fee_tax: compute_cookoon_fee_tax,
          services_price: compute_services_price,
          services_tax: compute_services_tax,
          services_full_price: compute_services_full_price,
          total_price: compute_total_price,
          total_tax: compute_total_tax,
          total_full_price: compute_total_full_price
        }
      end

      private
      
      def defaults
        self.class::DEFAULTS
      end

      def compute_cookoon_price
        duration * cookoon.price
      end

      def compute_degressive_cookoon_price
        degression_rate = degression_rates[duration] || 1
        compute_cookoon_price * degression_rate
      end

      def compute_cookoon_fee_minus_tax
        compute_degressive_cookoon_price * defaults[:fee_rate] / (1 + defaults[:tax_rate])
      end

      def compute_cookoon_fee
        compute_degressive_cookoon_price * defaults[:fee_rate]
      end

      def compute_cookoon_fee_tax
        compute_cookoon_fee_minus_tax * defaults[:tax_rate]
      end

      def compute_services_price
        services_price_cents = services.sum(:price_cents)
        Money.new(services_price_cents)
      end

      def compute_services_tax
        compute_services_price * defaults[:tax_rate]
      end

      def compute_services_full_price
        [compute_services_price, compute_services_tax].sum
      end

      def compute_total_price
        [compute_degressive_cookoon_price, compute_cookoon_fee_minus_tax, compute_services_price].sum
      end

      def compute_total_full_price
        [compute_total_price, compute_cookoon_fee_tax, compute_services_tax].sum
      end

      def compute_total_tax
        [compute_services_tax, compute_cookoon_fee_tax].sum
      end
    end
  end
end
