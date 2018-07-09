class RenameSearchToCookoonSearch < ActiveRecord::Migration[5.2]
  def change
    rename_table :searches, :cookoon_searches
  end
end
