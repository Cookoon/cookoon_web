class Service
  class Payment < ::Payment
    alias_attribute :chargeable, :service

    def should_capture?
      true
    end

    def description
      "Paiement des services pour #{payee.cookoon.name}"
    end
  end
end
