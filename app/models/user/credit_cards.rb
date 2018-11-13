class User
  class CreditCards
    attr_reader :user, :errors
    delegate :stripe_customer, to: :user

    def initialize(user)
      @user = user
    end

    def list
      user.retrieve_stripe_sources
    end

    def add(token)
      user.create_stripe_customer unless stripe_customer?
      user.create_stripe_source(token)
    end

    def destroy(card)
      user.destroy_stripe_source(card)
    end

    def default(card)
      user.default_stripe_source(card)
    end
  end
end
