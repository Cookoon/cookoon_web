class CreateEphemerals < ActiveRecord::Migration[5.1]
  def change
    create_table :ephemerals do |t|
      t.string :title
      t.text :description
      t.references :cookoon, foreign_key: true
      t.datetime :start_at
      t.integer :duration
      t.integer :people_count
      t.monetize :service_price, amount: { null: true, default: nil }
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
