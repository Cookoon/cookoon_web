class AddTrelloCardIdToCookoons < ActiveRecord::Migration[5.1]
  def change
    add_column :cookoons, :trello_card_id, :string
  end
end
