module Stripe
  module Transferable

    def trigger_stripe_transfer
      trigger_transfer
    end

    private

    def charge
      @charge ||= Stripe::Charge.retrieve(chargeable.stripe_charge_id)
    end

    def trigger_transfer
      # keep rescue ?
      Stripe::Transfer.create(transfer_options)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to trigger transfer for reservation : #{reservation.id}")
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end

    def transfer_options
      {
        amount: reservation.host_payout_price_cents,
        currency: 'eur',
        destination: reservation.cookoon.user.stripe_account_id,
        metadata: {
          discount_amount: ActionController::Base.helpers.humanized_money_with_symbol(reservation.discount_amount)
        }
      }
    end
  end
end
