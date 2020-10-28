module Admin
  class UsersController < ApplicationController
    before_action :find_hosts, only: %i[index_hosts]
    before_action :find_membership_asking, only: %i[index_membership_asking]
    before_action :find_user, only: %i[add_identity_documents send_invitation]

    def index_hosts
      @hosts_missing_stripe_account = @hosts.missing_stripe_account
      hosts_with_stripe_account = @hosts.with_stripe_account

      @hosts_missing_docs = []
      @hosts_missing_nothing = []

      hosts_with_stripe_account.each do |host|
        if host.stripe_account_requirements_currently_due?
          @hosts_missing_docs << host
        else
          @hosts_missing_nothing << host
        end
      end
    end

    def add_identity_documents
      @service = StripeAccountService.new(user: @user)
      if @service.add_identity_documents_for_existing_account
        redirect_to "#{@service.stripe_account_link_id_verification.url}"
        flash[:notice] = "Les documents ont bien été transmis à Stripe. Après validation de leur part, l'hôte pourra récupérer ses paiements en attente."
      else
        flash.now[:alert] = @service.error_messages
      end
    end

    def index_membership_asking
    end

    def send_invitation
      if @user.invite!(current_user)
        if @user.update(user_params)
          redirect_to membership_asking_admin_users_path, notice: "L'invitation a bien été envoyée."
        else
          redirect_to membership_asking_admin_users_path, alert: "L'invitation a bien été envoyée mais il y a eu un problème dans la demande de règlement"
        end
      else
        redirect_to membership_asking_admin_users_path, alert: "Il y a eu un problème, veuillez contacter le support."
      end
    end

    private

    def find_membership_asking
      @users_membership_asking = policy_scope([:admin, User]).membership_asking
    end

    def find_hosts
      @hosts = policy_scope([:admin, User]).has_cookoon
    end

    def find_user
      @user = User.find(params[:user_id])
      authorize @user, policy_class: Admin::UserPolicy
    end

    def user_params
      params.require(:user).permit(:inscription_payment_required, :membership_asking)
    end
  end
end
