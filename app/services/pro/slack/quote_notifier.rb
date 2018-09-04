module Pro
  module Slack
    class QuoteNotifier < ::Slack::BaseNotifier
      def initialize(attributes)
        @quote = attributes[:quote]
        @channel = '#devis-pro'
      end

      private

      attr_reader :quote

      def message
        "[NOUVELLE DEMANDE DE DEVIS] #{quote.user.full_name} vient de demander un devis pour la société #{quote.company.name} !"
      end
    end
  end
end
