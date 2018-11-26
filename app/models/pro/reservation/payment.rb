module Pro
  class Reservation
    class Payment < ::Payment
      include Stripe::Transferable

      alias_method :reservation, :payable
      delegate :company, :price_cents, to: :payable

      private

      def should_capture?
        true
      end

      def charge_amount_cents
        # price_cents
        1000
      end

      def charge_description
        "Paiement pour #{reservation.cookoon.name}"
      end

      def charge_metadata
        {
          reservation_id: reservation.id,
          reservation_price: reservation.price,
          reservation_services_price: reservation.services_price_full,
          reservation_services: reservation.services.pluck(:name).join(' · ')
        }
      end

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
