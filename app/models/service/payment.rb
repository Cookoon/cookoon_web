class Service
  class Payment < ::Payment
    include Discountable
    alias_method :service, :payable

    private

    # can be removed along with Discoutable
    def before_proceed
      persist_discount if discount_asked?
    end

    def should_capture?
      true
    end

    def charge_amount_cents
      discountable_charge_amount_cents
    end

    def charge_description
      "Paiement des services pour #{service.cookoon.name}"
    end
  end
end
