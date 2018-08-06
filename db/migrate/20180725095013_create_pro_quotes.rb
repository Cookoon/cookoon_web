class CreateProQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :pro_quotes do |t|
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
  end
end
