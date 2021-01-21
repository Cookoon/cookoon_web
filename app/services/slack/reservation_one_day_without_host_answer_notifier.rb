module Slack
  class ReservationOneDayWithoutHostAnswerNotifier < BaseNotifier
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
      "[URGENT - ATTENTE VALIDATION HOTE] #{host.full_name} n'a pas répondu pour la réservation #{reservation.id} du #{display_datetime_for(reservation.start_at, join_expression: 'à', without_year: true)}"
    end
  end
end
