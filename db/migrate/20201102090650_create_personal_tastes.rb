class CreatePersonalTastes < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_tastes do |t|
      t.string :favorite_champagne
      t.string :favorite_wine
      t.string :favorite_restaurant_one
      t.string :favorite_restaurant_two
      t.string :favorite_restaurant_three
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
