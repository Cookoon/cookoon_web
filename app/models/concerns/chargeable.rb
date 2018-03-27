module Chargeable
  attr_reader :charge, :customer

  def proceed
    retrieve_customer
    # handle_discount
    create_charge #if charge_needed?
    persist_charge_and_status
  end

  def authorize_charge
    retrieve_customer
    create_charge
    persist_charge_and_status
  end

  def create_charge

  end

  def capture
  end

  def displayable_errors
    if errors.any?
      errors.join(' ')
    else
      "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
    end
  end

  private

  def errors
    @errors ||= []
  end

  def persist_charge_and_status
    chargeable.update(status: :paid, stripe_charge_id: charge&.id)
  end

  def create_charge
    Stripe::Charge.create(charge_options)
  end

  def create_charge
    return false unless customer
    @charge = Stripe::Charge.create(charge_options)
  rescue Stripe::CardError, Stripe::InvalidRequestError => e
    Rails.logger.error('Failed to create Stripe Charge')
    Rails.logger.error(e.message)
    errors << e.message
    false
  end
end
