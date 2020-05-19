module Stripe
  module Chargeable
    # def create_stripe_intent
    def create_stripe_intent(cookoon_stripe_intent_id)
      create_intent
      # persist_intent
      persist_intent(cookoon_stripe_intent_id)
    end

    # def retrieve_and_update_stripe_intent
    def retrieve_and_update_stripe_intent(cookoon_stripe_intent_id)
      # retrieve_and_update_intent
      retrieve_and_update_intent(cookoon_stripe_intent_id)
      # persist_intent
      persist_intent(cookoon_stripe_intent_id)
    end

    def return_stripe_client_secret
      return_client_secret
    end

    # def capture_stripe_intent
    def capture_stripe_intent(cookoon_stripe_intent_id)
      # capture_intent
      capture_intent(cookoon_stripe_intent_id)
    end

    # def refund_stripe_charge
    # def cancel_stripe_intent
    def cancel_stripe_intent(cookoon_stripe_intent_id)
      # cancel_intent
      cancel_intent(cookoon_stripe_intent_id)
      # refund_charge
    end

    private

    attr_reader :stripe_intent

    # def refund_charge
    # def cancel_intent
    def cancel_intent(cookoon_stripe_intent_id)
      # return false unless intent
      return false unless intent(cookoon_stripe_intent_id)
      # intent.cancel
      intent(cookoon_stripe_intent_id).cancel
      # return false unless charge
      # charge.refund
    end

    # def capture_intent
    def capture_intent(cookoon_stripe_intent_id)
      # return false unless intent
      return false unless intent(cookoon_stripe_intent_id)
      # intent.capture
      intent(cookoon_stripe_intent_id).capture
    end

    # def intent
      def intent(cookoon_stripe_intent_id)
      # return false unless payable.stripe_charge_id
      return false unless payable[cookoon_stripe_intent_id]
      # @intent ||= Stripe::PaymentIntent.retrieve(payable.stripe_charge_id)
      @intent ||= Stripe::PaymentIntent.retrieve(payable[cookoon_stripe_intent_id])
    end

    # def persist_intent
    def persist_intent(cookoon_stripe_intent_id)
      # payable.update(stripe_charge_id: stripe_intent.id) if stripe_intent
      payable.update("#{cookoon_stripe_intent_id}": stripe_intent.id) if stripe_intent
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
        # capture_method: 'manual',
        capture_method: options[:capture_method],
        # source: options[:source],
        # capture: should_capture?
      }
    end

    # def retrieve_and_update_intent
    def retrieve_and_update_intent(cookoon_stripe_intent_id)
      # return false unless payable.stripe_charge_id
      return false unless payable[cookoon_stripe_intent_id]
      # @stripe_intent = Stripe::PaymentIntent.update(payable.stripe_charge_id, intent_attributes_update)
      @stripe_intent = Stripe::PaymentIntent.update(payable[cookoon_stripe_intent_id], intent_attributes_update)
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
