module Slack
  class ReservationNotifier < BaseNotifier
    include DatetimeHelper
    include ActionView::Helpers::TranslationHelper
    include MoneyRails::ActionViewExtension

    def initialize(attributes)
      @reservation = attributes[:reservation]
      @tenant = @reservation.user unless @reservation.amex?
      @cookoon = @reservation.cookoon
      @host = @cookoon.user
      # @channel = '#locations-dev' if Rails.env.development?
      @channel = '#réservations-staging' if Rails.env.staging?
      @channel = '#réservations' if Rails.env.production?
    end

    private

    attr_reader :reservation, :cookoon, :host, :tenant

    def message
      return unless reservation
      case reservation.aasm_state.to_sym
      # when :paid then paid_message
      when :charged
        "[NOUVELLE DEMANDE] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}
        pour #{reservation.people_count} personnes pendant #{reservation.duration} heures.
        #{url_for_admin_reservation}"
      when :accepted
        "[ACCEPTATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être acceptée par #{host.full_name}
        #{url_for_admin_reservation}"
      when :quotation_accepted_by_host
        "[ACCEPTATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être acceptée par #{host.full_name}
        #{url_for_admin_reservation}"
      when :refused
        "[REFUS] la location pour #{cookoon.name} le #{formatted_date} vient d'être refusée par #{host.full_name}
        #{url_for_admin_reservation}"
      when :quotation_refused_by_host
        "[REFUS] la location pour #{cookoon.name} le #{formatted_date} vient d'être refusée par #{host.full_name}
        #{url_for_admin_reservation}"
      when :quotation_asked
        "[NOUVELLE DEMANDE DE DEVIS EN ATTENTE DE VALIDATION HOTE] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}
        pour #{reservation.people_count} personnes pendant #{reservation.duration} heures.
        #{url_for_admin_reservation}"
      when :quotation_proposed
        "[DEVIS ENVOYE HORS APP PAR ADMINISTRATEUR] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}.
        #{url_for_admin_reservation}"
      when :quotation_accepted
        "[DEVIS ACCEPTE HORS APP] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}.
        #{url_for_admin_reservation}"
      when :menu_payment_captured
        "[NOUVEAU PAIEMENT MENU] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}.
        #{url_for_admin_reservation}"
      when :services_payment_captured
        "[NOUVEAU PAIEMENT SERVICES] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}.
        #{url_for_admin_reservation}"
      when :ongoing
        "[EN COURS] la location pour #{cookoon.name} par #{tenant.full_name} vient de démarrer.
        #{url_for_admin_reservation}"
      when :passed
        "[FIN] la location pour #{cookoon.name} par #{tenant.full_name} vient de se terminer.
        #{url_for_admin_reservation}"
      when :cancelled
        "[ANNULATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être annulée par Cookoon.
        #{url_for_admin_reservation}"
      when :cancelled_because_host_did_not_reply_in_validity_period
        "[ANNULATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être annulée car l'hôte n'a pas répondu dans les temps.
        #{url_for_admin_reservation}"
      when :cancelled_because_short_notice
        "[ANNULATION] la location pour #{cookoon.name} le #{formatted_date} vient d'être annulée car le délai est trop court.
        #{url_for_admin_reservation}"
      when :amex_asked
        "[NOUVELLE DEMANDE AMEX EN ATTENTE DE VALIDATION HOTE] #{cookoon.name} le #{formatted_date} par #{reservation.amex_code.first_name} #{reservation.amex_code.last_name}
        pour #{reservation.people_count} personnes pendant #{reservation.duration} heures.
        #{url_for_admin_reservation}"
      when :amex_accepted_by_host
        "[ACCEPTATION AMEX] la location pour #{cookoon.name} le #{formatted_date} vient d'être acceptée par #{host.full_name}
        #{url_for_admin_reservation}"
      when :amex_refused_by_host
        "[REFUS AMEX] la location pour #{cookoon.name} le #{formatted_date} vient d'être refusée par #{host.full_name}
        #{url_for_admin_reservation}"
      end
    end

    def formatted_date
      display_datetime_for(reservation.start_at, join_expression: 'à', without_year: true)
    end

    # def paid_message
    #   <<~MESSAGE
    #     [NOUVELLE DEMANDE] #{cookoon.name} le #{formatted_date} par #{tenant.full_name}
    #     pour #{reservation.people_count} personnes pendant #{reservation.duration} heures.

    #     Services associés :
    #     #{list_services}

    #     Total : #{humanized_money_with_symbol reservation.payment_amount}
    #   MESSAGE
    # end

    # def list_services
    #   return 'Aucun service supplémentaire' if reservation.services.none?
    #   # TODO CP 23/08/2019 refaire le message avec les nouveaux services
    #   []
    # end

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
