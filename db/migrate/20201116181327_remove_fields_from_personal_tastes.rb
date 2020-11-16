class RemoveFieldsFromPersonalTastes < ActiveRecord::Migration[5.2]
  def change
    remove_column :personal_tastes, :favorite_champagne, :string
    remove_column :personal_tastes, :favorite_wine, :string
    remove_column :personal_tastes, :favorite_restaurant_one, :string
    remove_column :personal_tastes, :favorite_restaurant_two, :string
    remove_column :personal_tastes, :favorite_restaurant_three, :string
  end
end
