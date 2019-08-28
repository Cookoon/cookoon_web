class AddQuantityToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :quantity, :integer
  end
end
