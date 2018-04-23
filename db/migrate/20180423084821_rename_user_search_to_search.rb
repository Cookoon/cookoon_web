class RenameUserSearchToSearch < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_searches, :address, :string
    rename_table :user_searches, :searches
  end
end
