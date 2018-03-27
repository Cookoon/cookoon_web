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

  def handle_payment_and_update_reservation
    retrieve_customer
    handle_discount
    create_charge if charge_needed?
    update_reservation
  end

  def capture_payment
    return true unless charge_needed?
    retrieve_charge
    capture_charge
  end

  def user_sources
    retrieve_customer
    retrieve_sources
  end

  def pay_service
    retrieve_customer
    handle_service_discount
    create_service_charge if service_charge_needed?
    update_service
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

  def handle_discount
    return unless ActiveModel::Type::Boolean.new.cast(@options[:discount])
    discount_amount_cents = compute_discount_cents
    reservation.discount_amount_cents = discount_amount_cents
    update_user_balance(reservation) if discount_amount_cents.positive?
  end

  def handle_service_discount
    return unless ActiveModel::Type::Boolean.new.cast(@options[:discount])
    discount_amount_cents = compute_service_discount_cents
    @service.discount_amount_cents = discount_amount_cents
    update_user_balance(@service) if discount_amount_cents.positive?
  end

  def compute_discount_cents
    return 0 unless user.available_discount?
    user_discount = user.discount_balance_cents
    reservation_price = reservation.price_with_tenant_fee_cents
    [user_discount, reservation_price].min
  end

  def compute_service_discount_cents
    return 0 unless user.available_discount?
    user_discount = user.discount_balance_cents
    service_price = @service.price_cents
    [user_discount, service_price].min
  end

  def update_user_balance(chargeable)
    user.discount_balance_cents -= chargeable.discount_amount_cents
    user.save
  end

  def charge_needed?
    reservation&.charge_amount_cents&.positive?
  end

  def service_charge_needed?
    @service&.charge_amount_cents&.positive?
  end

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

  def retrieve_sources
    return [] unless customer
    @sources = customer.sources.all(object: 'card')
  end

  def retrieve_charge
    return false unless reservation.stripe_charge_id
    @charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
  end

  def trigger_transfer
    Stripe::Transfer.create(transfer_options)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Failed to trigger transfer for reservation : #{reservation.id}")
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def transfer_options
    {
      amount: reservation.host_payout_price_cents,
      currency: 'eur',
      destination: user.stripe_account_id,
      metadata: {
        discount_amount: ActionController::Base.helpers.humanized_money_with_symbol(reservation.discount_amount)
      }
    }
  end

  def update_reservation
    reservation.update(status: :paid, stripe_charge_id: charge&.id)
  end

  def update_service
    @service.update(status: :paid, stripe_charge_id: charge&.id)
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
      amount: reservation.charge_amount_cents,
      currency: 'eur',
      customer: @customer.id,
      source: @source,
      description: "Paiement pour #{reservation.cookoon.name}",
      capture: false
    }
  end

  def create_service_charge
    return false unless customer
    @charge = Stripe::Charge.create(service_charge_options)
  rescue Stripe::CardError, Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create Stripe Charge')
    Rails.logger.error(e.message)
    @errors << e.message
    false
  end

  def service_charge_options
    {
      amount: @service.charge_amount_cents,
      currency: 'eur',
      customer: @customer.id,
      source: @source,
      description: "Paiement des services pour la réservation id #{reservation.id}"
    }
  end
end
