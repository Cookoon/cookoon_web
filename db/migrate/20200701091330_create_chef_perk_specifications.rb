class CreateChefPerkSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :chef_perk_specifications do |t|
      t.string :name

      t.timestamps
    end
  end
end
