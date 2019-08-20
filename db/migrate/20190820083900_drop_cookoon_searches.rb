class DropCookoonSearches < ActiveRecord::Migration[5.2]
  def change
    drop_table :cookoon_searches
  end
end
