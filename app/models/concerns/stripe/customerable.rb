module Stripe
  module Customerable
    def stripe_customer
      @stripe_customer ||= retrieve_customer
    end

    private

    def retrieve_customer
      Stripe::Customer.retrieve(stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to retrieve customer for #{user.email}")
      Rails.logger.error(e.message)
      # errors << e.message
      false
    end
  end
end
