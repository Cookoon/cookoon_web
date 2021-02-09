class CreateChefUnavailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :chef_unavailabilities do |t|
      t.boolean :available, default: false
      t.date :date
      t.integer :time_slot
      t.datetime :start_at
      t.datetime :end_at
      t.references :chef, foreign_key: true

      t.timestamps
    end
  end
end
