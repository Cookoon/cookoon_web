class User
  class CreditCards
    attr_reader :user, :errors
    delegate :stripe_customer, to: :user

    def initialize(user)
      @user = user
    end

    def list
      # user.retrieve_stripe_sources
      user.retrieve_stripe_payment_methods
    end

    # def add(token)
    def add(payment_method)
      user.create_stripe_customer unless user.stripe_customer?
      # user.link_stripe_source(token)
      user.link_stripe_payment_method(payment_method)
    end

    def destroy(card)
      user.destroy_stripe_source(card)
    end

    def default(card)
      user.default_stripe_source(card)
    end
  end
end
