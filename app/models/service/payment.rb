class Service
  class Payment < ::Payment
    include Discountable

    private

    alias_attribute :chargeable, :service

    # can be removed along with Discoutable
    def before_proceed
      persist_discount if discount_asked?
    end

    def discount_asked?
      ActiveModel::Type::Boolean.new.cast(options[:discount])
    end

    def should_capture?
      true
    end

    def charge_amount_cents
      discountable_charge_amount_cents
    end

    def charge_description
      "Paiement des services pour #{chargeable.cookoon.name}"
    end
  end
end
