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
      @charge ||= Stripe::Charge.retrieve(payee.stripe_charge_id)
    end

    def persist_charge
      payee.update(stripe_charge_id: stripe_charge&.id)
    end

    def create_charge
      # keep rescue ?
      return false unless user&.stripe_customer
      @stripe_charge = Stripe::Charge.create(charge_options)
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to create Stripe Charge')
      Rails.logger.error(e.message)
      errors << e.message
      # could instantiate a Payment::Unprocessable
      false
    end

    def charge_options
      # add metadata ?
      {
        amount: computed_charge_amount_cents,
        currency: 'eur',
        customer: user.stripe_customer.id,
        source: options[:source],
        description: description,
        capture: should_capture?
      }
    end
  end
end
