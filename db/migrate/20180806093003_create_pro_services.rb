class CreateProServices < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_services do |t|
      t.references :pro_reservation, foreign_key: true
      t.string :name
      t.integer :quantity
      t.monetize :unit_price
      t.monetize :price

      t.timestamps
    end
  end
end
