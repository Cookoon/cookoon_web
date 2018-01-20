class StripeAccountsController < ApplicationController
  before_action :get_service, :build_infos

  def new
  end

  def create
    if @account_service.create_and_link_account
      flash[:notice] = 'Votre compte est maintenant lié avec Stripe. Vous pourrez prochainement récupérer vos paiements en attente'
      redirect_to edit_users_path
    else
      flash.now[:alert] = @account_service.error_messages
      render :new
    end
  end

  private

  def check_params
    # return if params[:stripe].blank?
    # address_params = [params['address']['city'], params['address']['street'], params['address']['post_code']]
    # dob_params = [params['dob(1i)'], params['dob(2i)'], params['dob(2i)']]
    # @errors << 'Votre adresse est obligatoire' if address_params.any?(&:blank?)
    # @errors << 'Votre date de naissance est obligatoire' if dob_params.any?(&:blank?)
    # @errors << 'Votre IBAN est obligatoire' if params['iban'].blank?
  end

  def get_service
    authorize [:stripe_account, current_user]
    @account_service = StripeAccountService.new(params: params[:stripe], user: current_user)
  end

  def build_infos
    # if params[:stripe]
    #   @infos = {
    #     day: params[:stripe]["dob(2i)"].to_i || 1,
    #     month: params[:stripe]["dob(2i)"].to_i || 1,
    #     year: params[:stripe]["dob(1i)"].to_i || 1960,
    #     city: params[:stripe][:address][:city],
    #     street: params[:stripe][:address][:street],
    #     post_code: params[:stripe][:address][:post_code]
    #   }
    # else
    #   account = @account_service.retrieve_stripe_account
    #   @infos = {
    #     day: account.try(:legal_entity).try(:dob).try(:day) || 1,
    #     month: account.try(:legal_entity).try(:dob).try(:month) || 1,
    #     year: account.try(:legal_entity).try(:dob).try(:year) || 1960,
    #     city: account.try(:legal_entity).try(:address).try(:city),
    #     street: account.try(:legal_entity).try(:address).try(:line1),
    #     post_code: account.try(:legal_entity).try(:address).try(:postal_code)
    #   }
    # end
  end
end
