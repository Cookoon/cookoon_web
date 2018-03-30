class Reservation
  class Payment < ::Payment
    include Stripe::Transferable

    def transfer
      trigger_stripe_transfer
    end

    def should_capture?
      false
    end

    def description
      "Paiement pour #{payee.cookoon.name}"
    end

    def transfer_amount
      payee.host_payout_price_cents
    end

    def transfer_destination
      payee.cookoon.user.stripe_account_id
    end
  end
end
