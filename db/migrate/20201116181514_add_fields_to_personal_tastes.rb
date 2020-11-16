class AddFieldsToPersonalTastes < ActiveRecord::Migration[5.2]
  def change
    add_column :personal_tastes, :favorite_restaurants, :string
    add_column :personal_tastes, :favorite_wines, :string
  end
end
