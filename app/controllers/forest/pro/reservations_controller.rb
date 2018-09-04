module Forest
  module Pro
    class ReservationsController < ForestLiana::ApplicationController
      def propose_reservation
        reservation = ::Pro::Reservation.find(params.dig(:data, :attributes, :ids)&.first)

        reservation.proposed!
        ::Pro::ReservationMailer.proposed(reservation).deliver_later

        render json: { success: 'Pro::Reservation is proposed and mail sent' }
      end
    end
  end
end
