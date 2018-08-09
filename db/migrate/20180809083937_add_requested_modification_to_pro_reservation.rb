class AddRequestedModificationToProReservation < ActiveRecord::Migration[5.2]
  def change
    add_column :pro_reservations, :requested_modification, :text
  end
end
