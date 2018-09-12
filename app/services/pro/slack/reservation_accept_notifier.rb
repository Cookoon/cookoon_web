module Pro
  module Slack
    class ReservationAcceptNotifier < ::Slack::BaseNotifier
      def initialize(attributes)
        @reservation = attributes[:reservation]
        @channel = '#devis-pro'
      end

      private

      attr_reader :reservation

      def message
        "[DEVIS ACCEPTE] #{reservation.user.full_name} vient d'accepter le devis pour la société #{reservation.company} !"
      end
    end
  end
end
