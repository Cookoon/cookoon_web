module Forest
  class ReservationsController < ForestLiana::ApplicationController
    def cancel_by_host
      confirmed = params.dig(:data, :attributes, :values, :confirmed)
      return render(json: { error: 'You must confirm' }, status: :bad_request) unless confirmed

      ids = params.dig(:data, :attributes, :ids).map(&:to_i)
      reservations = ::Reservation.where(id: ids)

      reservations.each do |reservation|
        if reservation.cancelled!
          # ReservationMailer.cancelled_by_host_to_host(reservation).deliver_later
          # ReservationMailer.cancelled_by_host_to_tenant(reservation).deliver_later
        end
      end

      render json: { html: '<h1>Congratulations Quentin!</h1><p>You are awesome, just stay who you are.</p>' }
    end
  end
end
