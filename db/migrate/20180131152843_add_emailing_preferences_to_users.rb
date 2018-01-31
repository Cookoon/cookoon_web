class AddEmailingPreferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :emailing_preferences, :integer, default: 1
  end
end
