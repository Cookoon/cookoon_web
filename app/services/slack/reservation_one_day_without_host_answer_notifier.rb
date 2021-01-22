module Slack
  class ReservationOneDayWithoutHostAnswerNotifier < BaseNotifier
    include DatetimeHelper
    include ActionView::Helpers::TranslationHelper

    def initialize(attributes)
      @reservation = attributes[:reservation]
      @host = @reservation.cookoon.user
      @channel = '#urgences-staging' if Rails.env.staging?
      @channel = '#urgences' if Rails.env.production?
    end

    private

    attr_reader :reservation, :host

    def message
      "[URGENT - ATTENTE VALIDATION HOTE] #{host.full_name} n'a pas répondu pour la réservation #{reservation.id} du #{formatted_date}
      #{url_for_admin_reservation}"
    end

    def formatted_date
      display_datetime_for(reservation.start_at, join_expression: 'à', without_year: true)
    end

    def url_for_admin_reservation
      case Rails.env
      when "staging"
        "https://cookoon-staging.herokuapp.com/admin/reservations/#{reservation.id}"
      when "production"
        "https://membre.cookoon.club/admin/reservations/#{reservation.id}"
      # when "development"
        # "http://localhost:3000/admin/reservations/#{reservation.id}"
      end
    end
  end
end
