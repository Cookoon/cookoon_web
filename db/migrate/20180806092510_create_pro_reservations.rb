class CreateProReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_reservations do |t|
      t.integer :status, default: 0, null: false
      t.references :pro_quote, foreign_key: true
      t.references :cookoon, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :duration
      t.integer :people_count
      t.monetize :cookoon_price
      t.monetize :services_price
      t.monetize :fee
      t.monetize :price

      t.timestamps
    end
  end
end
