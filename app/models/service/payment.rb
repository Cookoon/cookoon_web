class Service
  class Payment
    include Stripe::Chargeable

    attr_reader :service, :options

    delegate :user, :charge_amount_cents, :cookoon, to: :service
    delegate :stripe_customer, to: :user

    alias_attribute :chargeable, :service

    def initialize(service, options = {})
      @service = service
      @options = options
    end

    def should_capture?
      true
    end

    def description
      "Paiement des services pour #{cookoon.name}"
    end
  end
end
