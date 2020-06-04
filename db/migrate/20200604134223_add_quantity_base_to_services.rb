class AddQuantityBaseToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :quantity_base, :integer, default: 0, null: false
  end
end
