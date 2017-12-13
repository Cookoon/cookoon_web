class StripePaymentService
  attr_accessor :user, :token, :reservation, :customer, :charge, :sources, :source

  def initialize(attributes)
    @user = attributes[:user]
    @token = attributes[:token]
    @source = attributes[:source]
    @reservation = attributes[:reservation]
    @errors = []
    retrieve_customer if user.stripe_customer_id
  end

  def create_charge_and_update_reservation
    return unless retrieve_customer
    update_reservation if create_charge
  end

  def capture_charge
    retrieve_charge
    begin
      charge.capture
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error('Failed to capture Charge')
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end
  end

  def user_sources
    return unless user.stripe_customer_id
    @sources = customer.sources.all(object: 'card')
  end

  def tax_and_payout
    pay_cookoon
    payout
  end

  def add_source_to_customer
    retrieve_or_create_customer
    create_source_for_customer
  end

  def set_default_card(card)
    return false unless card
    customer.default_source = card.id
    customer.save
  end

  def destroy_card(card)
    customer.sources.retrieve(card).delete
  end

  def displayable_errors
    @errors.join(' ')
  end

  private

  def pay_cookoon
    Stripe::Charge.create(
      amount: reservation.total_fees_with_services_for_host_cents,
      currency: 'eur',
      source: user.stripe_account_id
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to create Charge for cookoon options, source: #{user.stripe_account_id}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def payout
    Stripe::Payout.create(
      {
        amount: reservation.payout_price_for_host_cents,
        currency: 'eur'
      },
      {
        stripe_account: user.stripe_account_id
      }
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to create Stripe Payout for #{user.stripe_account_id}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
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

  def retrieve_or_create_customer
    @customer.nil? ? create_customer : @customer
  end

  def retrieve_customer
    @customer = Stripe::Customer.retrieve(user.stripe_customer_id)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to retrieve customer for #{user.email}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def retrieve_charge
    @charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
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
    @charge = Stripe::Charge.create(
      amount: reservation.price_for_rent_with_fees_cents,
      currency: 'eur',
      customer: @customer.id,
      source: @source,
      description:  "Paiement pour #{reservation.cookoon.name}",
      capture: false,
      destination: {
        amount: reservation.price_for_rent_cents,
        account: reservation.cookoon.user.stripe_account_id
      }
    )
  rescue Stripe::CardError, Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create Stripe Charge')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end
end
