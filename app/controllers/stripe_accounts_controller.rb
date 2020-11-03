class StripeAccountsController < ApplicationController
  before_action :pundit_authorize
  before_action :stripe_service, only: :create

  def new; end

  def create
    if @service.create_and_link_account
      # redirect_to "#{@service.stripe_account_link_id_verification.url}"
      flash[:notice] = 'Votre compte est maintenant lié avec Stripe. Vous pourrez prochainement récupérer vos paiements en attente'
      redirect_to host_dashboard_path
    else
      flash.now[:alert] = @service.error_messages
      render :new
    end

    # if @service.create_and_link_account
    #   flash[:notice] = 'Votre compte est maintenant lié avec Stripe. Vous pourrez prochainement récupérer vos paiements en attente'
    #   redirect_to edit_users_path
    # else
    #   flash.now[:alert] = @service.error_messages
    #   render :new
    # end
  end

  # # To implement later
  # def add_identity_documents
  #   @service = StripeAccountService.new(user: current_user)
  #   if @service.add_identity_documents_for_existing_accounts
  #     redirect_to "#{@service.stripe_account_link_id_verification.url}"
  #     flash[:notice] = 'Vos documents ont bien été transmis à Stripe. Vous pourrez après validation de leur part récupérer vos paiements en attente.'
  #   else
  #     flash.now[:alert] = @service.error_messages
  #   end
  # end

  private

  def stripe_service
    @service = StripeAccountService.new(params: params[:stripe_account], user: current_user)
  end

  def pundit_authorize
    authorize [:stripe_account, current_user]
  end
end
