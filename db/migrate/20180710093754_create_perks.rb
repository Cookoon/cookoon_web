class CreatePerks < ActiveRecord::Migration[5.2]
  def change
    create_table :perks do |t|
      t.references :cookoon, foreign_key: true
      t.references :perk_specification, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
