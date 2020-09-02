module Admin
  class UsersController < ApplicationController
    before_action :find_hosts, only: %i[index]
    before_action :find_host, only: %i[add_identity_documents]

    def index
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
      @service = StripeAccountService.new(user: @host)
      if @service.add_identity_documents_for_existing_account
        redirect_to "#{@service.stripe_account_link_id_verification.url}"
        flash[:notice] = "Les documents ont bien été transmis à Stripe. Après validation de leur part, l'hôte pourra récupérer ses paiements en attente."
      else
        flash.now[:alert] = @service.error_messages
      end
    end

    private

    def find_hosts
      @hosts = policy_scope([:admin, User]).has_cookoon
    end

    def find_host
      @host = User.find(params[:user_id])
      authorize @host, policy_class: Admin::UserPolicy
    end
  end
end
