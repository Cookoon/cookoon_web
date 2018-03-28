class Service
  class Payment
    include Stripe::Chargeable
    include Discountable

    attr_reader :service, :options

    delegate :user, :payment_amount_cents, :cookoon, to: :service

    alias_attribute :chargeable, :service

    def initialize(service, options = {})
      @service = service
      @options = options
    end

    def proceed
      persist_discount if discount_asked?
      create_stripe_charge if charge_needed?
      service.paid!
    end

    def refund
      refund_stripe_charge
      refund_user_discount
    end

    def should_capture?
      true
    end

    def description
      "Paiement des services pour #{cookoon.name}"
    end
  end
end
