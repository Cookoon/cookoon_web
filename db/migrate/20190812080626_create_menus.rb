class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :chef, foreign_key: true
      t.string :description
      t.integer :unit_price_cents

      t.timestamps
    end
  end
end
