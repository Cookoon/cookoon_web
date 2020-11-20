class ChangeMessageForHostToMessageInReservations < ActiveRecord::Migration[5.2]
  def change
    rename_column :reservations, :message_for_host, :message
  end
end
