class AddCategoryToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :category, :integer, default: 0, null: false
  end
end
