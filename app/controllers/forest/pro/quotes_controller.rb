module Forest
  module Pro
    class QuotesController < ForestLiana::ApplicationController
      def create_draft_reservation
        head :no_content
      end
    end
  end
end
