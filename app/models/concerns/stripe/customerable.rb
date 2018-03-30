module Stripe
  module Customerable
    def stripe_customer
      return nil unless stripe_customer_id
      @stripe_customer ||= retrieve_customer
    end

    def create_stripe_customer
      customer = create_customer
      update_user(customer)
      customer
    end

    def create_stripe_source(token)
      create_source(token)
    end

    def retrieve_stripe_sources
      return [] unless stripe_customer
      stripe_customer.sources.all(object: 'card')
    end

    def destroy_stripe_source(card)
      stripe_customer.sources.retrieve(card).delete
    end

    def default_stripe_source(card)
      return false unless card
      stripe_customer.default_source = card.id
      stripe_customer.save
    end

    private

    def update_user(customer)
      user.update(stripe_customer_id: customer.id) if customer
    end

    def retrieve_customer
      Stripe::Customer.retrieve(stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to retrieve customer for #{email}")
      Rails.logger.error(e.message)
      errors.add(:customer, 'Failed to retrieve stripe customer')
      false
    end

    def create_customer
      Stripe::Customer.create(
        description: "Customer for #{user.email}",
        email: user.email
      )
    end

    def create_source(token)
      stripe_customer.sources.create(source: token)
    rescue Stripe::CardError => e
      Rails.logger.error("Failed to create credit_card for #{email}")
      Rails.logger.error(e.message)
      errors.add(:credit_card, e.message)
      false
    end
  end
end
