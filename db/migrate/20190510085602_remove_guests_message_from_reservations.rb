class RemoveGuestsMessageFromReservations < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :guests_message
  end
end
