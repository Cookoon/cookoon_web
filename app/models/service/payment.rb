class Service
  class Payment < ::Payment
    alias_method :service, :payable

    private

    def should_capture?
      true
    end

    def after_proceed
      service.paid! if errors.empty?
    end

    def charge_amount_cents
      service.price_cents
    end

    def charge_description
      "Paiement des services pour #{service.cookoon.name}"
    end
  end
end
