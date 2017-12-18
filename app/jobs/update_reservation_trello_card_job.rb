class UpdateReservationTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    service = TrelloReservationService.new(reservation: reservation)
    reservation.accepted? ? service.enrich_and_move_card : service.move_card
  end
end
