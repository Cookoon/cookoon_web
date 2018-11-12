module Stripe
  module Chargeable
    def create_stripe_charge
      create_charge
      persist_charge
    end

    def capture_stripe_charge
      capture_charge
    end

    def refund_stripe_charge
      refund_charge
    end

    private

    attr_reader :stripe_charge

    def refund_charge
      return false unless charge
      charge.refund
    end

    def capture_charge
      return false unless charge
      charge.capture
    end

    def charge
      return false unless payable.stripe_charge_id
      @charge ||= Stripe::Charge.retrieve(payable.stripe_charge_id)
    end

    def persist_charge
      payable.update(stripe_charge_id: stripe_charge.id) if stripe_charge
    end

    def create_charge
      # keep rescue ?
      return false unless user&.stripe_customer
      @stripe_charge = Stripe::Charge.create(charge_attributes)
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to create Stripe Charge')
      Rails.logger.error(e.message)
      errors << e.message
      # could instantiate a Payment::Unprocessable
      false
    end

    def charge_attributes
      # add metadata ?
      {
        amount: charge_amount_cents,
        currency: 'eur',
        customer: user.stripe_customer.id,
        source: options[:source],
        description: charge_description,
        metadata: charge_metadata,
        capture: should_capture?
      }
    end
  end
end
