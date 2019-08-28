class AddDefaultPriceCentsToServices < ActiveRecord::Migration[5.2]
  def change
    change_column_null :services, :price_cents, false, 0
    change_column_default :services, :price_cents, from: nil, to: 0
  end
end
