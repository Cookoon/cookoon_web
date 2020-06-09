class AddMinPriceCentsToChefs < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :min_price_cents, :integer, default: 0, null: false
  end
end
