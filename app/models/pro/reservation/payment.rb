module Pro
  class Reservation
    class Payment < ::Payment
      include Stripe::Transferable
      alias_method :reservation, :payable
      # include Stripe::SepaCreditable

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
