class AddUnitPriceCentsToServices < ActiveRecord::Migration[5.2]
  def change
    add_monetize :services, :unit_price, currency: { present: false }
  end
end
