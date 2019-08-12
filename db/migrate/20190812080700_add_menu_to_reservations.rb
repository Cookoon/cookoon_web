class AddMenuToReservations < ActiveRecord::Migration[5.2]
  def change
    add_reference :reservations, :menu, foreign_key: true
  end
end
