module Pro
  class PingSlackReservationModificationRequestJob < ApplicationJob
    queue_as :default

    def perform(reservation_id)
      reservation = Reservation.find(reservation_id)
      service = Slack::ReservationModificationRequestNotifier.new(reservation: reservation)
      service.notify
    end
  end
end
