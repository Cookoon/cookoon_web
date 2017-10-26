class StripeAccountsController < ApplicationController
  before_action :get_service, :build_infos

  def new
  end

  def create
    @account_service.retrieve_or_create_user_account unless @account_service.errors.any?

    if @account_service.enrich_account
      flash[:notice] = "Votre compte est maintenant lié avec Stripe. Vous pourrez prochainement récupérer vos paiements en attente"
      redirect_to edit_users_path
    else
      flash.now[:alert] = @account_service.error_messages
      render :new
    end
  end

  private

  def get_service
    authorize [:stripe_account, current_user]
    @account_service = StripeAccountService.new(params: params[:stripe], user: current_user, request_ip: request.remote_ip)
  end

  def build_infos
    if params[:stripe]
      @infos = {
        day: params[:stripe]["dob(2i)"].to_i || 1,
        month: params[:stripe]["dob(2i)"].to_i || 1,
        year: params[:stripe]["dob(1i)"].to_i || 1960,
        city: params[:stripe][:address][:city],
        street: params[:stripe][:address][:street],
        post_code: params[:stripe][:address][:post_code]
      }
    else
      account = @account_service.retrieve_stripe_account
      @infos = {
        day: account.try(:legal_entity).try(:dob).try(:day) || 1,
        month: account.try(:legal_entity).try(:dob).try(:month) || 1,
        year: account.try(:legal_entity).try(:dob).try(:year) || 1960,
        city: account.try(:legal_entity).try(:address).try(:city),
        street: account.try(:legal_entity).try(:address).try(:line1),
        post_code: account.try(:legal_entity).try(:address).try(:postal_code)
      }
    end
  end
end
