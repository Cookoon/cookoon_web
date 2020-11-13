class AddAmexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :amex, :boolean, default: false
  end
end
