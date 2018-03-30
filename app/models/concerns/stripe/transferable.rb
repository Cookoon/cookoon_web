module Stripe
  module Transferable
    def trigger_stripe_transfer
      trigger_transfer
    end

    private

    def trigger_transfer
      # keep rescue ?
      Stripe::Transfer.create(transfer_options)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to trigger transfer for reservation : #{reservation.id}")
      Rails.logger.error(e.message)
      errors << e.message
      # could instantiate a Payment::Unprocessable
      false
    end

    def transfer_options
      {
        amount: transfer_amount,
        currency: 'eur',
        destination: transfer_destination,
        metadata: {
          discount_amount: ActionController::Base.helpers.humanized_money_with_symbol(reservation.discount_amount)
        }
      }
    end
  end
end
