class Reservation
  class Payment
    include Stripe::Chargeable
    include Discountable

    attr_reader :reservation, :options

    delegate :user, :payment_amount_cents, :cookoon, to: :reservation

    alias_attribute :chargeable, :reservation
    alias_attribute :discountable, :reservation

    def initialize(reservation, options = {})
      @reservation = reservation
      @options = options
    end

    def proceed
      persist_discount if discount_asked?
      create_stripe_charge if charge_needed?
      reservation.paid!
    end

    def refund
      refund_stripe_charge
      refund_user_discount
    end

    def capture
      capture_stripe_charge
    end

    def should_capture?
      false
    end

    def description
      "Paiement pour #{cookoon.name}"
    end
  end
end
