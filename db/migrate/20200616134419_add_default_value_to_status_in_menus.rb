class AddDefaultValueToStatusInMenus < ActiveRecord::Migration[5.2]
  def change
    change_column :menus, :status, :string, default: "initial"
  end
end
