class Reservation
  class Payment < ::Payment
    include Stripe::Transferable
    alias_method :reservation, :payable

    def charge
      reservation.charge! if errors.empty?
    end

    def pay_services
      reservation.pay_services! if errors.empty?
    end

    def capture_menu_payment
      reservation.capture_menu_payment! if errors.empty?
      reservation.update(menu_status: "captured")
    end

    private

    # def should_capture?
    #   ActiveModel::Type::Boolean.new.cast(options[:capture]) || false
    # end

    # def charge_amount_cents
    #   reservation.business? ? reservation.total_price_cents : reservation.total_with_tax_cents
    # end

    def intent_description
      "Paiement pour #{reservation.cookoon.name}"
    end

    def intent_metadata
      {
        reservation_id: reservation.id,
        reservation_price: options[:charge_amount_cents],
        reservation_services_price: reservation.services_with_tax_cents,
        reservation_services: reservation.services.payment_tied_to_reservation.pluck(:name).join(' · ')
      }
    end

    # def transfer_metadata
    #   {}
    # end

    # def transfer_amount
    #   reservation.host_payout_price_cents
    # end

    # def transfer_destination
    #   reservation.cookoon.user.stripe_account_id
    # end
  end
end


# # Code Charles
# class Reservation
#   class Payment < ::Payment
#     include Stripe::Transferable
#     alias_method :reservation, :payable

#     private

#     def after_proceed
#       reservation.charge! if errors.empty?
#     end

#     def should_capture?
#       ActiveModel::Type::Boolean.new.cast(options[:capture]) || false
#     end

#     def charge_amount_cents
#       reservation.business? ? reservation.total_price_cents : reservation.total_with_tax_cents
#     end

#     def charge_description
#       "Paiement pour #{reservation.cookoon.name}"
#     end

#     def charge_metadata
#       {
#         reservation_id: reservation.id,
#         reservation_price: charge_amount_cents,
#         reservation_services_price: reservation.services_with_tax_cents,
#         reservation_services: reservation.services.payment_tied_to_reservation.pluck(:name).join(' · ')
#       }
#     end

#     def transfer_metadata
#       {}
#     end

#     def transfer_amount
#       reservation.host_payout_price_cents
#     end

#     def transfer_destination
#       reservation.cookoon.user.stripe_account_id
#     end
#   end
# end
