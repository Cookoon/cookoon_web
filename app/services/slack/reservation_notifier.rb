module Slack
  class ReservationNotifier < BaseNotifier
    include DatetimeHelper
    include ActionView::Helpers::TranslationHelper

    def initialize(attributes)
      @reservation = attributes[:reservation]
      @tenant = @reservation.user
      @cookoon = @reservation.cookoon
      @host = @cookoon.user
      @channel = '#locations'
    end

    private

    attr_reader :reservation, :cookoon, :host, :tenant

    def message
      return unless reservation
      case reservation.status.to_sym
      when :paid
        "[NOUVELLE DEMANDE] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}"
      when :accepted
        "[ACCEPTATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être acceptée par #{host.full_name}"
      when :refused
        "[REFUS] la location pour #{cookoon.name} le #{formatted_date} vient d'être refusée par #{host.full_name}"
      when :ongoing
        "[EN COURS] la location pour #{cookoon.name} par #{tenant.full_name} vient de démarrer"
      when :passed
        "[FIN] la location pour #{cookoon.name} par #{tenant.full_name} vient de se terminer"
      when :cancelled
        "[ANNULATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être annulée"
      end
    end

    def formatted_date
      display_datetime_for(reservation.start_at, join_expression: 'à', without_year: true)
    end
  end
end