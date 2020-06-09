class ChangeTypeOfDescriptionInChefs < ActiveRecord::Migration[5.2]
  def change
    change_column :chefs, :description, :text
  end
end
