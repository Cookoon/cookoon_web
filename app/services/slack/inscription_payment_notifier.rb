module Slack
  class InscriptionPaymentNotifier < BaseNotifier
    def initialize(attributes)
      @user = attributes[:user]
      @channel = '#users-dev' if Rails.env.development?
      @channel = '#users-staging' if Rails.env.staging?
      @channel = '#users' if Rails.env.production?
    end

    private

    attr_reader :user

    def message
      "[PAIEMENT INSCRIPTION] #{@user.full_name} (#{@user.email}) a réglé les frais d'inscription."
    end

  end
end
