class CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  before_action :set_paiement_service

  def index
    @stripe_sources = @paiement_service.user_sources
  end

  def create
    @paiement_service.token = params[:credit_card][:stripe_token]
    # add_source
    card = @paiement_service.add_source_to_customer

    # set as default card if asked
    @paiement_service.set_default_card(card) if params[:credit_card][:default] == "1"
    if card
      redirect_to credit_cards_path
    else
      @stripe_sources = @paiement_service.user_sources
      flash.now[:alert] = @paiement_service.displayable_errors
      render :index
    end
  end

  def destroy
    @paiement_service.destroy_card(params[:id])
    redirect_to credit_cards_path
  end

  private

  def set_paiement_service
    @paiement_service = StripePaiementService.new(
      user: current_user
    )
  end
end
