class PingSlackReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    service = Slack::ReservationNotifier.new(reservation: reservation)
    service.notify
  end
end
