class CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  before_action :set_paiement_service

  def index
    @stripe_sources = @paiement_service.user_sources
  end

  def create
    # retrieve or create customer
    # add_source + set it as default ?
    @paiement_service.token = params[:credit_card][:stripe_token]
    @paiement_service.add_source_to_customer

    redirect_to credit_cards_path
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
