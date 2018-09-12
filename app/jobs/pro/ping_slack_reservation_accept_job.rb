module Pro
  class PingSlackReservationAcceptJob < ApplicationJob
    queue_as :default

    def perform(reservation_id)
      reservation = Reservation.find(reservation_id)
      service = Slack::ReservationAcceptNotifier.new(reservation: reservation)
      service.notify
    end
  end
end
