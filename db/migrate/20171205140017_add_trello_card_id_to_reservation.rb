class AddTrelloCardIdToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :trello_card_id, :string
  end
end
