class AddAmexToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :amex, :boolean, default: false
  end
end
