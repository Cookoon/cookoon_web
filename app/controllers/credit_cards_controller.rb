class CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def secret
    set_up_intent = Stripe::SetupIntent.create()
    @set_up_intent_json = {client_secret: set_up_intent.client_secret}.to_json
  end

  def index
    @credit_cards = current_user.credit_cards
    @default_payment_method = credit_card.find_default_payment_method
  end

  def create
    card = credit_card.add(credit_card_params[:stripe_token])
    credit_card.default(card) if set_card_as_default?
    handle_redirection(card)
  end

  def destroy
    credit_card.destroy(params[:id])
    redirect_to credit_cards_path
  end

  private

  def handle_redirection(card)
    referer_infos = Rails.application.routes.recognize_path(request.referer)

    if referer_infos.key?(:reservation_id) && card
      return redirect_to new_reservation_payment_path(referer_infos[:reservation_id])
    elsif referer_infos[:controller] == "inscription_payments" && card
      return redirect_to new_inscription_payment_path
    end

    flash[:alert] = current_user.errors.full_messages.join(', ') unless card
    redirect_to credit_cards_path
  end

  def credit_card_params
    params.require(:credit_card)
  end

  def credit_card
    current_user.credit_card
  end

  def set_card_as_default?
    credit_card_params[:default] == '1'
  end
end
