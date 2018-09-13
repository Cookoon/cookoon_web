class CreatePerkSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :perk_specifications do |t|
      t.string :name
      t.string :icon_name

      t.timestamps
    end
  end
end
