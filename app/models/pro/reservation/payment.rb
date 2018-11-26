module Pro
  class Reservation
    class Payment < ::Payment
      include Stripe::Transferable

      alias_method :reservation, :payable
      delegate :company, to: :payable

      private

      def transfer_amount
        reservation.host_payout_price_cents
      end

      def transfer_destination
        reservation.cookoon.user.stripe_account_id
      end

      def stripe_customer
        return nil unless company.stripe_customer?
        company.stripe_customer
      end
    end
  end
end
