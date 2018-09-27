module Forest
  module Pro
    class ReservationsController < ForestLiana::ApplicationController
      def add_service_from_specification
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)

        service_specification = ::Pro::ServiceSpecification.find(params.dig(:data, :attributes, :values, :service_specification_id))
        quantity = params.dig(:data, :attributes, :values, :quantity).to_i

        reservation.services.create(
          service_specification.attributes.slice('name', 'unit_price_cents')
            .merge(quantity: quantity)
        )
      end

      def propose_reservation
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)
        message = params.dig(:data, :attributes, :values, :message)

        reservation.draft_initial? ? reservation.proposed_initial! : reservation.proposed!
        ::Pro::ReservationMailer.proposed(reservation, message).deliver_later

        render json: { success: 'Pro::Reservation is proposed and mail sent' }
      end

      def duplicate_reservation_as_draft
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)

        new_reservation = ::Pro::Reservation.create(
          reservation.attributes.slice('pro_quote_id', 'cookoon_id', 'start_at', 'duration', 'people_count')
            .merge(status: :draft)
        )

        reservation.services.each do |service|
          new_reservation.services.create(
            service.attributes.slice('name', 'quantity', 'unit_price_cents')
          )
        end

        reservation.modification_processed!

        render json: { success: 'Pro::Reservation is duplicated as draft' }
      end
    end
  end
end
