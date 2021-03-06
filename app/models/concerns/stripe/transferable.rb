module Stripe
  module Transferable
    def transfer
      trigger_transfer
    end

    private

    def trigger_transfer
      # keep rescue ?
      Stripe::Transfer.create(transfer_attributes)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to trigger transfer for reservation : #{reservation.id}")
      Rails.logger.error(e.message)
      errors << e.message
      # could instantiate a Payment::Unprocessable
      false
    end

    def transfer_attributes
      {
        amount: transfer_amount,
        currency: 'eur',
        destination: transfer_destination
      }.merge(transfer_metadata)
    end
  end
end
