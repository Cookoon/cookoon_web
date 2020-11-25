module Slack
  class UserNotifier < BaseNotifier
    def initialize(attributes)
      @user = attributes[:user]
      # @channel = '#users-dev' if Rails.env.development?
      @channel = '#users-staging' if Rails.env.staging?
      @channel = '#users' if Rails.env.production?
    end

    private

    attr_reader :user

    def message
      "[NOUVEL UTILISATEUR] #{@user.full_name} demande à devenir membre.
      #{url_for_admin_memberhip_asking}"
    end

    def url_for_admin_memberhip_asking
      case Rails.env
      when "staging"
        "https://cookoon-staging.herokuapp.com/admin/users/membership_asking"
      when "production"
        "https://membre.cookoon.club/admin/users/membership_asking"
      # when "development"
      #   "http://localhost:3000/admin/users/membership_asking"
      # end
    end
  end
end
