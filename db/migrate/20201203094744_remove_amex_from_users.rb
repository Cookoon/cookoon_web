class RemoveAmexFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :amex, :boolean
  end
end
