class RemoveTypeFromMenus < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :type, :string
  end
end
