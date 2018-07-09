class RemoveTrelloCardIdFromCookoonsAndReservations < ActiveRecord::Migration[5.2]
  def change
    remove_column :cookoons, :trello_card_id
    remove_column :reservations, :trello_card_id
  end
end
