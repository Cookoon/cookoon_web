class AddTypeToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :type, :string
  end
end
