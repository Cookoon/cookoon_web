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

    def displayable_errors
      if errors.any?
        errors.join(' ')
      else
        "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
      end
    end

    private

    attr_reader :stripe_charge

    def errors
      @errors ||= []
    end

    def refund_charge
      return false unless charge
      charge.refund
    end

    def capture_charge
      return false unless charge
      charge.capture
    end

    def charge
      @charge ||= Stripe::Charge.retrieve(chargeable.stripe_charge_id)
    end

    def persist_charge
      chargeable.update(stripe_charge_id: stripe_charge&.id)
    end

    def create_charge
      return false unless user&.stripe_customer
      @stripe_charge = Stripe::Charge.create(charge_options)
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to create Stripe Charge')
      Rails.logger.error(e.message)
      errors << e.message
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
