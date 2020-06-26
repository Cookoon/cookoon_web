class AddReferencesToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :references, :text
  end
end
