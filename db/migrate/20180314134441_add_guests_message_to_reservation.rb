class AddGuestsMessageToReservation < ActiveRecord::Migration[5.1]
  def change
    add_column :reservations, :guests_message, :text
  end
end
