class Payment
  include Stripe::Chargeable
  include Discountable

  attr_reader :chargeable, :options, :errors

  delegate :user, :payment_amount_cents, to: :chargeable

  def initialize(chargeable, options = {})
    @chargeable = chargeable
    @options = options
    @errors = []
  end

  def proceed
    # #discount_asked? and #charge_needed? sit within #discountable
    # when removing discountable need to override this method in other payments
    persist_discount if discount_asked?
    create_stripe_charge if charge_needed?
    errors.empty? ? chargeable.paid! : false
  end

  def refund
    refund_stripe_charge
    refund_user_discount
  end

  def capture
    capture_stripe_charge
  end

  def displayable_errors
    if errors.any?
      errors.join(' ')
    else
      "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
    end
  end
end
