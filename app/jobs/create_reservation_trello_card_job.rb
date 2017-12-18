class CreateReservationTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    service = TrelloReservationService.new(reservation: reservation)
    card = service.create_trello_card
    reservation.update(trello_card_id: card.id) if card
  end
end
