class StripePaymentService
  attr_accessor :user, :token, :reservation, :customer, :charge, :sources, :source

  def initialize(attributes, options = {})
    @user = attributes[:user]
    @token = attributes[:token]
    @source = attributes[:source]
    @reservation = attributes[:reservation]
    @service = attributes[:service]
    @options = options
    @errors = []
  end

  def add_source_to_customer
    retrieve_or_create_customer
    create_source_for_customer
  end

  # This method should do stripe logic in private section
  def default_card(card)
    return false unless card
    retrieve_customer
    customer.default_source = card.id
    customer.save
  end

  # Same as above This method should do stripe logic in private section
  def destroy_card(card)
    retrieve_customer
    customer.sources.retrieve(card).delete
  end

  def displayable_errors
    if @errors.any?
      @errors.join(' ')
    else
      "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
    end
  end

  private

  def retrieve_or_create_customer
    create_customer unless retrieve_customer
  end

  def retrieve_customer
    return false unless user
    @customer ||= Stripe::Customer.retrieve(user.stripe_customer_id)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to retrieve customer for #{user.email}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def create_customer
    @customer = Stripe::Customer.create(
      description: "Customer for #{user.email}",
      email: user.email
    )
    user.update(stripe_customer_id: customer.id)
    customer
  end

  def create_source_for_customer
    customer.sources.create(source: token)
  rescue Stripe::CardError => e
    Rails.logger.error("Failed to create credit_card for #{user.email}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end
end
