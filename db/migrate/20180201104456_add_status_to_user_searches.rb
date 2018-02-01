class AddStatusToUserSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :user_searches, :status, :integer, default: 0, null: false
  end
end
