class DropProTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :pro_services do |t|
      t.references :pro_reservation, foreign_key: true
      t.string :name
      t.integer :quantity
      t.monetize :unit_price
      t.monetize :price

      t.timestamps
    end

    drop_table :pro_reservations do |t|
      t.integer :status, default: 0, null: false
      t.references :pro_quote, foreign_key: true
      t.references :cookoon, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :duration
      t.integer :people_count
      t.text :requested_modification
      t.monetize :cookoon_price
      t.monetize :cookoon_fee
      t.monetize :total_full_price
      t.monetize :services_price
      t.monetize :cookoon_fee_tax
      t.monetize :services_tax
      t.monetize :total_price
      t.monetize :services_full_price
      t.monetize :total_tax
      t.string :stripe_charge_id

      t.timestamps
    end

     drop_table :pro_quote_cookoons do |t|
      t.references :pro_quote, foreign_key: true
      t.references :cookoon, foreign_key: true

      t.timestamps
    end

    drop_table :pro_quote_services do |t|
      t.references :pro_quote, foreign_key: true
      t.integer :category, default: 0, null: false
      t.integer :quantity
    end

    drop_table :pro_quotes do |t|
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :duration
      t.integer :people_count
      t.text :comment

      t.timestamps
    end

    drop_table :pro_service_specifications do |t|
      t.string :name
      t.monetize :unit_price

      t.timestamps
    end
  end
end
