class StripeAccountsController < ApplicationController
  before_action :pundit_authorize
  before_action :stripe_service, only: :create

  def new; end

  def create
    if @service.create_and_link_account
      flash[:notice] = 'Votre compte est maintenant lié avec Stripe. Vous pourrez prochainement récupérer vos paiements en attente'
      redirect_to edit_users_path
    else
      flash.now[:alert] = @service.error_messages
      render :new
    end
  end

  private

  def stripe_service
    @service = StripeAccountService.new(params: params[:stripe], user: current_user)
  end

  def pundit_authorize
    authorize [:stripe_account, current_user]
  end
end
