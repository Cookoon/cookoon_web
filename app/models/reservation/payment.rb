class Reservation
  class Payment < ::Payment
    include Discountable
    include Stripe::Transferable

    def transfer
      trigger_stripe_transfer
    end

    private

    # can be removed along with Discoutable
    def before_proceed
      persist_discount if discount_asked?
    end

    def discount_asked?
      ActiveModel::Type::Boolean.new.cast(options[:discount])
    end

    def should_capture?
      ActiveModel::Type::Boolean.new.cast(options[:capture]) || false
    end

    def charge_amount_cents
      discountable_charge_amount_cents
    end

    def charge_description
      "Paiement pour #{chargeable.cookoon.name}"
    end

    def charge_metadata
      {
        reservation_id: chargeable.id,
        reservation_price: chargeable.price,
        reservation_services_price: chargeable.services_price,
        reservation_tenant_fee: chargeable.tenant_fee,
        reservation_host_fee: chargeable.host_fee,
        reservation_services: chargeable.services.payment_tied_to_reservation.pluck(:category).join(' · ')
      }
    end

    def transfer_amount
      chargeable.host_payout_price_cents
    end

    def transfer_destination
      chargeable.cookoon.user.stripe_account_id
    end

    def discount_amount_used
      ActionController::Base.helpers.humanized_money_with_symbol(chargeable.discount_amount)
    end
  end
end
