class CreateReservationTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    service = TrelloReservationService.new(reservation: reservation)
    service.create_trello_card
  end
end
