class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.boolean :available, default: false
      t.references :cookoon, foreign_key: true
      t.date :date
      t.integer :time_slot
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
