module Stripe
  module Customerable
    class AlreadyCustomerError < StandardError
      def message
        "This User or Company already has a Stripe Customer attached"
      end
    end

    def stripe_customer
      return nil unless stripe_customer_id
      @stripe_customer ||= retrieve_customer
    end

    def create_stripe_customer
      raise AlreadyCustomerError if stripe_customer?

      customer = create_customer
      update_customerable(customer)
      customer
    end

    # def link_stripe_source(token)
    def link_stripe_payment_method(payment_method)
      # link_source(token)
      link_payment_method(payment_method)
    end

    # can pass source instead of card to retrive sepa
    # def retrieve_stripe_sources(object = 'card')
    def retrieve_stripe_payment_methods(object = 'card')
      return [] unless stripe_customer
      # Stripe::Customer.list_sources(stripe_customer.id, { object: object })
      Stripe::PaymentMethod.list({ customer: stripe_customer.id, type: object })
    end

    # def destroy_stripe_source(source)
    def detach_stripe_payment_method(payment_method)
      # Stripe::Customer.delete_source(stripe_customer.id, source)
      Stripe::PaymentMethod.detach(payment_method)
    end

    def default_stripe_source(card)
      return false unless card
      stripe_customer.default_source = card.id
      stripe_customer.save
    end

    def stripe_customer?
      stripe_customer_id.present?
    end

    private

    def update_customerable(customer)
      update(stripe_customer_id: customer.id) if customer
    end

    def retrieve_customer
      Stripe::Customer.retrieve(stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to retrieve customer for #{customerable_label}")
      Rails.logger.error(e.message)
      errors.add(:customer, 'Failed to retrieve stripe customer')
      false
    end

    def create_customer
      Stripe::Customer.create(
        description: "Customer for #{customerable_label}",
        email: try(:email)
      )
    end

    # def link_source(token)
    def link_payment_method(payment_method)
      # Stripe::Customer.create_source(stripe_customer.id, { source: token })
      Stripe::PaymentMethod.attach(payment_method, { customer: stripe_customer.id })
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to create stripe source for #{customerable_label}")
      Rails.logger.error(e.message)
      # errors.add(:stripe_source, e.message)
      errors.add(:stripe_payment_method, e.message)
      false
    end

    def create_sepa_source
      Stripe::Source.create({
        type: 'sepa_credit_transfer',
        currency: 'eur',
        owner: {
          name: name,
          email: referent_email,
        }
      })
    end

    def persist_sepa_source
      sources = retrieve_stripe_sources('source')
      return nil if sources.empty?
      sepa_infos = sources.data.first['sepa_credit_transfer']
      if sepa_infos
        update(
          stripe_bank_name: sepa_infos.bank_name,
          stripe_bic: sepa_infos.bic,
          stripe_iban: sepa_infos.iban
        )
      end
    end
  end
end
