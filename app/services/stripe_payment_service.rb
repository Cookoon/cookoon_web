class StripePaymentService
  attr_accessor :user, :token, :reservation, :customer, :charge, :sources, :source

  def initialize(attributes)
    @user = attributes[:user]
    @token = attributes[:token]
    @source = attributes[:source]
    @reservation = attributes[:reservation]
    @errors = []
  end

  def create_charge_and_update_reservation
    retrieve_customer
    create_charge
    update_reservation
  end

  def capture_payment
    retrieve_charge
    capture_charge
  end

  def user_sources
    retrieve_customer
    retrieve_sources
  end

  def pay_host
    retrieve_charge
    trigger_transfer
  end

  def add_source_to_customer
    retrieve_or_create_customer
    create_source_for_customer
  end

  # This method should do stripe logic in private section
  def default_card(card)
    return false unless card
    customer.default_source = card.id
    customer.save
  end

  # Same as above This method should do stripe logic in private section
  def destroy_card(card)
    customer.sources.retrieve(card).delete
  end

  def displayable_errors
    @errors.join(' ')
  end

  private

  def retrieve_sources
    return false unless customer
    @sources = customer.sources.all(object: 'card')
  end

  def retrieve_charge
    return false unless reservation.stripe_charge_id
    @charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
  end

  def retrieve_customer
    @customer ||= Stripe::Customer.retrieve(user.stripe_customer_id)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to retrieve customer for #{user.email}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def retrieve_or_create_customer
    @customer ? create_customer : @customer
  end

  def trigger_transfer
    return false unless charge
    Stripe::Transfer.create(transfer_options)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to trigger transfer for #{charge.id}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def transfer_options
    {
      amount: reservation.payout_price_for_host_cents,
      currency: 'eur',
      source_transaction: charge.id,
      destination: user.stripe_account_id
    }
  end

  def update_reservation
    reservation.update(status: :paid, stripe_charge_id: @charge.id)
  end

  def create_customer
    @customer = Stripe::Customer.create(
      description: "Customer for #{user.email}",
      email: user.email
    )
    user.update(stripe_customer_id: customer.id)
    @customer
  end

  def capture_charge
    return false unless charge
    charge.capture
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to capture Charge')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def create_source_for_customer
    customer.sources.create(source: token)
  rescue Stripe::CardError => e
    Rails.logger.error("Failed to create credit_card for #{user.email}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def create_charge
    return false unless customer
    @charge = Stripe::Charge.create(charge_options)
  rescue Stripe::CardError, Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create Stripe Charge')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def charge_options
    {
      amount: reservation.price_for_rent_with_fees_cents,
      currency: 'eur',
      customer: @customer.id,
      source: @source,
      description:  "Paiement pour #{reservation.cookoon.name}",
      capture: false
    }
  end
end
