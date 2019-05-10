class RemoveGuests < ActiveRecord::Migration[5.2]
  def change
    drop_table :reservation_guests
    drop_table :guests
  end
end
