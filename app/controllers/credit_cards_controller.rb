class CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  before_action :set_payment_service

  def index
    @stripe_sources = current_user.credit_cards
  end

  def create
    card = @payment_service.add_source_to_customer
    @payment_service.default_card(card) if params[:credit_card][:default] == '1'
    handle_redirection(card)
  end

  def destroy
    @payment_service.destroy_card(params[:id])
    redirect_to credit_cards_path
  end

  private

  def handle_redirection(card)
    if card
      redirect_to credit_cards_path
    else
      @stripe_sources = @payment_service.user_sources
      flash.now[:alert] = @payment_service.displayable_errors
      render :index
    end
  end

  def set_payment_service
    @payment_service = StripePaymentService.new(
      user: current_user,
      token: params.dig(:credit_card, :stripe_token)
    )
  end
end
