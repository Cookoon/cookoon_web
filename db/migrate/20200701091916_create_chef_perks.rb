class CreateChefPerks < ActiveRecord::Migration[5.2]
  def change
    create_table :chef_perks do |t|
      t.integer :order
      t.references :chef, foreign_key: true
      t.references :chef_perk_specification, foreign_key: true

      t.timestamps
    end
  end
end
