class CreateReservationGuests < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_guests do |t|
      t.references :reservation, foreign_key: true
      t.references :guest, foreign_key: true
    end
  end
end
