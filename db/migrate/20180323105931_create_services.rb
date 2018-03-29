class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.references :reservation, foreign_key: true
      t.text :content
      t.monetize :price, amount: { null: true, default: nil }
      t.integer :status, default: 0, null: false
      t.string :stripe_charge_id
      t.integer :discount_amount_cents, default: 0, null: false

      t.timestamps
    end
  end
end