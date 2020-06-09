class AddBasePriceCentsToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :base_price_cents, :integer, default: 0, null: false
  end
end
