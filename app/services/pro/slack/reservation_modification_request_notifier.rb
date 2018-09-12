module Pro
  module Slack
    class ReservationModificationRequestNotifier < ::Slack::BaseNotifier
      def initialize(attributes)
        @reservation = attributes[:reservation]
        @channel = '#devis-pro'
      end

      private

      attr_reader :reservation

      def message
        "[DEMANDE DE MODIFICATION DE DEVIS] #{reservation.user.full_name} vient de demander une modification de devis pour la société #{reservation.company} !"
      end
    end
  end
end
