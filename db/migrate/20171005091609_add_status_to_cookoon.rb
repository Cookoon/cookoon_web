class AddStatusToCookoon < ActiveRecord::Migration[5.1]
  def change
    add_column :cookoons, :status, :integer, default: 0
  end
end
