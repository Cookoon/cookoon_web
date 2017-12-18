class CreateCookoonTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(cookoon_id)
    cookoon = Cookoon.find(cookoon_id)
    service = TrelloCookoonService.new(cookoon: cookoon)
    card = service.create_trello_card
    cookoon.update(trello_card_id: card.id) if card
  end
end
