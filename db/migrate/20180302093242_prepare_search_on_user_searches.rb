class PrepareSearchOnUserSearches < ActiveRecord::Migration[5.1]
  def change
    rename_column :user_searches, :date, :start_at
    rename_column :user_searches, :number, :people_count
    add_column :user_searches, :end_at, :datetime
  end
end
