module Slack
  class HostNotifier < BaseNotifier
    def initialize(attributes)
      @user = attributes[:user]
      @channel = '#recrutement-hôte'
    end

    private

    attr_reader :user

    def message
      "[NOUVEAU RIB] #{@user.full_name} vient d'ajouter son RIB !"
    end
  end
end
