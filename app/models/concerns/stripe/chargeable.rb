module Stripe
  module Chargeable
    def create_stripe_intent
      create_intent
      persist_intent
    end

    def retrieve_and_update_stripe_intent
      retrieve_and_update_intent
      persist_intent
    end

    def return_stripe_client_secret
      return_client_secret
    end

    def capture_stripe_intent
      capture_intent
    end

  #   def refund_stripe_charge
  #     refund_charge
  #   end

    private

    attr_reader :stripe_intent

  #   def refund_charge
  #     return false unless charge
  #     charge.refund
  #   end

    def capture_intent
      return false unless intent
      intent.capture
    end

    def intent
      return false unless payable.stripe_charge_id
      @intent ||= Stripe::PaymentIntent.retrieve(payable.stripe_charge_id)
    end

    def persist_intent
      payable.update(stripe_charge_id: stripe_intent.id) if stripe_intent
    end

    def create_intent
      return false unless stripe_customer
      @stripe_intent = Stripe::PaymentIntent.create(intent_attributes_creation)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to create Stripe Payment Intent')
      Rails.logger.error(e.message)
      errors << e.message
      # could instantiate a Payment::Unprocessable
      false
    end

    def intent_attributes_creation
      {
        amount: charge_amount_cents,
        currency: 'eur',
        customer: stripe_customer.id,
        description: intent_description,
        metadata: intent_metadata,
        capture_method: 'manual',
        # source: options[:source],
        # capture: should_capture?
      }
    end

    def retrieve_and_update_intent
      return false unless payable.stripe_charge_id
      @stripe_intent = Stripe::PaymentIntent.update(payable.stripe_charge_id, intent_attributes_update)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to retrieve Stripe Payment Intent')
      Rails.logger.error(e.message)
      errors << e.message
      false
    end

    def intent_attributes_update
      {
        amount: charge_amount_cents,
        currency: 'eur',
        customer: stripe_customer.id,
        description: intent_description,
        metadata: intent_metadata,
      }
    end

    def return_client_secret
      return stripe_intent.client_secret if stripe_intent
    end
  end
end


# # Code Charles
# module Stripe
#   module Chargeable
#     def create_stripe_charge
#       create_charge
#       persist_charge
#     end

#     def capture_stripe_charge
#       capture_charge
#     end

#     def refund_stripe_charge
#       refund_charge
#     end

#     private

#     attr_reader :stripe_charge

#     def refund_charge
#       return false unless charge
#       charge.refund
#     end

#     def capture_charge
#       return false unless charge
#       charge.capture
#     end

#     def charge
#       return false unless payable.stripe_charge_id
#       @charge ||= Stripe::Charge.retrieve(payable.stripe_charge_id)
#     end

#     def persist_charge
#       payable.update(stripe_charge_id: stripe_charge.id) if stripe_charge
#     end

#     def create_charge
#       # keep rescue ?
#       return false unless stripe_customer
#       @stripe_charge = Stripe::Charge.create(charge_attributes)
#     rescue Stripe::CardError, Stripe::InvalidRequestError => e
#       Rails.logger.error('Failed to create Stripe Charge')
#       Rails.logger.error(e.message)
#       errors << e.message
#       # could instantiate a Payment::Unprocessable
#       false
#     end

#     def charge_attributes
#       {
#         amount: charge_amount_cents,
#         currency: 'eur',
#         customer: stripe_customer.id,
#         source: options[:source],
#         description: charge_description,
#         metadata: charge_metadata,
#         capture: should_capture?
#       }
#     end
#   end
# end
