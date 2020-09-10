class AddMealTypeToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :meal_type, :string
  end
end
