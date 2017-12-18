class CreateCookoonTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(cookoon_id)
    cookoon = Cookoon.find(cookoon_id)
    service = TrelloCookoonService.new(cookoon: cookoon)
    card_id = service.create_trello_card
    cookoon.update(trello_card_id: card_id) if card_id
  end
end
