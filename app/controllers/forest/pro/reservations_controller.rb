module Forest
  module Pro
    class ReservationsController < ForestLiana::ApplicationController
      def propose_reservation
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)

        reservation.proposed!
        ::Pro::ReservationMailer.proposed(reservation).deliver_later

        render json: { success: 'Pro::Reservation is proposed and mail sent' }
      end

      def duplicate_reservation_as_draft
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)

        new_reservation = ::Pro::Reservation.create(
          reservation.attributes.slice('pro_quote_id', 'cookoon_id', 'start_at', 'duration', 'people_count')
        )

        reservation.services.each do |service|
          new_reservation.services.create(
            name: service.name,
            quantity: service.quantity,
            unit_price_cents: service.unit_price_cents
          )
        end

        render json: { success: 'Pro::Reservation is duplicated as draft' }
      end
    end
  end
end
