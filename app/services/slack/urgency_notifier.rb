module Slack
  class UrgencyNotifier < BaseNotifier
    include DatetimeHelper

    def initialize(attributes)
      @reservation = attributes[:reservation]
      @host = @reservation.cookoon.user
      @channel = '#urgences-staging' if Rails.env.staging?
      @channel = '#urgences' if Rails.env.production?
    end

    private

    attr_reader :reservation, :host

    def message
      "[URGENT - ATTENTE VALIDATION HOTE] #{@host.full_name} n'a pas répondu pour la réservation #{@reservation.id} du #{@reservation.formatted_date}"
    end
  end
end
