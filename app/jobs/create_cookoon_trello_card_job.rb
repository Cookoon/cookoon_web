class CreateCookoonTrelloCardJob < ApplicationJob
  queue_as :default

  def perform(cookoon_id)
    cookoon = Cookoon.find(cookoon_id)
    service = TrelloCookoonService.new(cookoon: cookoon)
    service.create_trello_card
  end
end
