class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.text :name
      t.string :category
      t.integer :order
      t.references :menu, foreign_key: true

      t.timestamps
    end
  end
end
