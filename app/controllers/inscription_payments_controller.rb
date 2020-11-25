class InscriptionPaymentsController < ApplicationController

  def inscription_stripe_intent
    authorize :inscription_payment, :inscription_stripe_intent?
    create_or_retrieve_and_update_stripe_intent('automatic', User::Payment::INSCRIPTION_PRICE_CENTS, :stripe_inscription_id)
  end

  def secret_inscription
    authorize :inscription_payment, :secret_inscription?
    secret('automatic', User::Payment::INSCRIPTION_PRICE_CENTS, :stripe_inscription_id)
  end

  def new
    authorize :inscription_payment, :new?
    @url_intent_secret_inscription = "/users/inscription_payments/secret_inscription.json"
    @credit_cards = current_user.credit_cards
    @payment_method_to_display_first = current_user.find_default_stripe_payment_method || @credit_cards.first
  end

  def create
    authorize :inscription_payment, :create?
    payment = current_user.payment
    if payment.capture_inscription_payment
      flash.notice = "Votre paiement a bien été effectué."
      redirect_to home_path
      payment.report_to_slack_new_inscription_payment
    else
      flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
      redirect_to new_inscription_payment_path
    end
  end

  private

  def secret(capture_method_value, charge_amount_cents_value, stripe_charge_id_value)
    payment = User::Payment.new(current_user, options = { capture_method: capture_method_value, charge_amount_cents: charge_amount_cents_value })
    proceed_payment(payment, stripe_charge_id_value)
  end

  def proceed_payment(payment, stripe_intent)
    if payment.create_or_retrieve_and_update(stripe_intent)
      @stripe_intent = payment.return_stripe_intent
    else
      flash.alert = payment.displayable_errors
      redirect_to secret_inscription_inscription_payments_path
    end
  end

  def create_or_retrieve_and_update_stripe_intent(capture_method_value, charge_amount_cents_value, stripe_intent)
    payment = User::Payment.new(current_user, options = { capture_method: capture_method_value, charge_amount_cents: charge_amount_cents_value })
    payment.create_or_retrieve_and_update(stripe_intent)
  end
end
