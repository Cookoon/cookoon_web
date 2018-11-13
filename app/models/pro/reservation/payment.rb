module Pro
  class Reservation
    class Payment < ::Payment
      include Stripe::Transferable
      alias_method :reservation, :payable
      # include Stripe::SepaCreditable

      def proceed
        create_source
        add_source
      end

      private

      def should_capture?
        true
      end

      def charge_amount_cents
        price_cents
      end
    end
  end
end
