class Payment
  include Stripe::Chargeable

  attr_reader :payable, :options, :errors

  delegate :user, :payment_amount_cents, to: :payable

  STATUSES = {
    later: "A régler plus tard",
    charged: "Débit en attente",
    required: "A régler ce jour",
    paid: "Déjà réglé",
    cancelled: "Décliné par l'hôte",
    quotation_asked: "Devis en cours d'élaboration",
    quotation_proposed: "Devis en attente de validation de votre part",
    quotation_accepted: "Devis accepté",
    quotation_refused: "Devis refusé",
    temporary: "Montant provisoire"
  }.freeze

  def initialize(payable, options = {})
    @payable = payable
    @options = options
    @errors = []
  end

  # def create_or_retrieve_and_update
  def create_or_retrieve_and_update(cookoon_stripe_intent_id)
    # payable.stripe_charge_id.nil? ? create : retrieve_and_update
    payable[cookoon_stripe_intent_id].nil? ? create(cookoon_stripe_intent_id) : retrieve_and_update(cookoon_stripe_intent_id)
  end

  # def create
  def create(cookoon_stripe_intent_id)
    # create_stripe_intent if charge_needed?
    create_stripe_intent(cookoon_stripe_intent_id) if charge_needed?
  end

  # def retrieve_and_update
  def retrieve_and_update(cookoon_stripe_intent_id)
    # retrieve_and_update_stripe_intent
    retrieve_and_update_stripe_intent(cookoon_stripe_intent_id)
  end

  # def refund
  # def cancel
  def cancel(cookoon_stripe_intent_id)
    # refund_stripe_charge
    # cancel_stripe_intent
    cancel_stripe_intent(cookoon_stripe_intent_id)
  end

  # def capture
  def capture(cookoon_stripe_intent_id)
    # capture_stripe_intent
    capture_stripe_intent(cookoon_stripe_intent_id)
  end

  def displayable_errors
    if errors.any?
      errors.join(' ')
    else
      "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
    end
  end

  private

  # def before_proceed; end

  # def after_proceed; end

  def charge_needed?
    options[:charge_amount_cents].positive?
  end

  # def charge_amount_cents
  #   # could raise a NotImplementedError because should never be called
  #   # Each specific Payment Class needs to implement this method
  #   payment_amount_cents
  # end

  # def charge_metadata
  #   {}
  # end

  # def transfer_metadata
  #   {}
  # end

  def stripe_customer
    return nil unless user.stripe_customer?
    user.stripe_customer
  end
end


# # Code Charles
# class Payment
#   include Stripe::Chargeable

#   attr_reader :payable, :options, :errors

#   delegate :user, :payment_amount_cents, to: :payable

#   def initialize(payable, options = {})
#     @payable = payable
#     @options = options
#     @errors = []
#   end

#   def proceed
#     before_proceed
#     create_stripe_charge if charge_needed?
#     after_proceed
#   end

#   def refund
#     refund_stripe_charge
#   end

#   def capture
#     capture_stripe_charge
#   end

#   def displayable_errors
#     if errors.any?
#       errors.join(' ')
#     else
#       "Une erreur est survenue avec notre prestataire de paiement, essayez à nouveau ou contactez notre service d'aide"
#     end
#   end

#   private

#   def before_proceed; end

#   def after_proceed; end

#   def charge_needed?
#     charge_amount_cents.positive?
#   end

#   def charge_amount_cents
#     # could raise a NotImplementedError because should never be called
#     # Each specific Payment Class needs to implement this method
#     payment_amount_cents
#   end

#   def charge_metadata
#     {}
#   end

#   def transfer_metadata
#     {}
#   end

#   def stripe_customer
#     return nil unless user.stripe_customer?
#     user.stripe_customer
#   end
# end
