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
      "Paiement pour #{chargeable.cookoon.name}"
    end

    def transfer_amount
      chargeable.host_payout_price_cents
    end

    def transfer_destination
      chargeable.cookoon.user.stripe_account_id
    end
  end
end
