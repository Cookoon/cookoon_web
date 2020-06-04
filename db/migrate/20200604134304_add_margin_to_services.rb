class AddMarginToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :margin, :float, default: 0, null: false
  end
end
