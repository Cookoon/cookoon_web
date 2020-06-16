class AddStatusToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :status, :string
  end
end
