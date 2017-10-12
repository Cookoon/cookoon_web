class StripePaiementService
  attr_reader :user, :token, :reservation, :customer, :charge

  def initialize(attributes)
    @user = attributes[:user]
    @token = attributes[:token]
    @reservation = attributes[:reservation]
    @errors = []
  end

  def create_charge_and_update_reservation
    retrieve_or_create_customer
    update_reservation if create_charge
  end

  def capture_charge
    retrieve_charge
    begin
      charge.capture
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to capture Charge")
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end
  end

  def tax_and_payout
    pay_cookoon
    payout
  end

  def displayable_errors
    @errors.join(" ")
  end

  private

  def pay_cookoon
    begin
      Stripe::Charge.create(
        :amount => reservation.total_fees_with_services_for_host.fractional,
        :currency => "eur",
        :source => user.stripe_account_id
      )
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to create Charge for cookoon options, source: #{user.stripe_account_id}")
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end
  end

  def payout
    begin
      Stripe::Payout.create({
        :amount => reservation.payout_price_for_host.fractional,
        :currency => "eur",
      }, {:stripe_account => user.stripe_account_id})
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to create Stripe Payout for #{user.stripe_account_id}")
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end
  end

  def update_reservation
    reservation.update(status: :paid, stripe_charge_id: @charge.id)
  end

  def retrieve_or_create_customer
    user.stripe_customer_id ? retrieve_customer : create_customer
  end

  # le customer est créé avec sa carte
  # TODO: faire en sorte que le user puisse choisir parmi ses cartes sur le #new
  # sans avoir à saisir a nouveau.
  def create_customer
    @customer = Stripe::Customer.create(
      :description => "Customer for #{user.email}",
      :source => token
    )
    user.update(stripe_customer_id: customer.id)
    return @customer
  end

  def retrieve_customer
    @customer = Stripe::Customer.retrieve(user.stripe_customer_id)
  end

  def retrieve_charge
    @charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
  end

  def create_charge
    begin
      @charge = Stripe::Charge.create({
        amount: reservation.price_for_rent_with_fees.fractional,
        currency: 'eur',
        customer: @customer.id,
        description:  "Paiement pour #{reservation.cookoon.name}",
        capture: false,
        destination: {
          amount: reservation.price_for_rent.fractional,
          account: reservation.cookoon.user.stripe_account_id
        }
      })
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      Rails.logger.error("Failed to create Stripe Charge")
      Rails.logger.error(e.message)
      @errors << e.message
      false
    end
  end
end
