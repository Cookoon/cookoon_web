class User::CreditCards
  attr_reader :user, :customer
  delegate :stripe_customer, to: :user

  def initialize(user)
    @user = user
  end

  def list
    retrieve_sources
  end

  private

  def retrieve_sources
    return [] unless stripe_customer
    stripe_customer.sources.all(object: 'card')
  end
end
