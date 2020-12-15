class AddAmexPriceCentsToCookoons < ActiveRecord::Migration[5.2]
  def change
    add_column :cookoons, :amex_price_cents, :integer, default: 0
  end
end
