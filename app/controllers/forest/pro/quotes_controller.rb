module Forest
  module Pro
    class QuotesController < ForestLiana::ApplicationController
      def create_draft_reservation
        quote = ::Pro::Quote.find(params.dig(:data, :attributes, :ids)&.first)

        reservation = ::Pro::Reservation.create(
          {
            quote: quote,
            cookoon: quote.cookoons.first
          }.merge(quote.attributes.slice('start_at', 'duration', 'people_count'))
        )

        quote.services.each do |service|
          reservation.services.create(
            name: service.category.capitalize,
            quantity: service.quantity,
            unit_price_cents: service.unit_price_cents
          )
        end

        render json: { success: 'Draft Pro::Reservation was created' }
      end
    end
  end
end
