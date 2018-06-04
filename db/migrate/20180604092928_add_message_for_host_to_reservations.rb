class AddMessageForHostToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :message_for_host, :text
  end
end
