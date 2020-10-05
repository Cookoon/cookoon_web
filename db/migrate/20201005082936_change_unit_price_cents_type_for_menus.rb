class ChangeUnitPriceCentsTypeForMenus < ActiveRecord::Migration[5.2]
  def change
    change_column :menus, :unit_price_cents, :decimal, default: 0, null: false
  end
end
