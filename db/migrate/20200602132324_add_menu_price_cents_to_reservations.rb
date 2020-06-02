class AddMenuPriceCentsToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :menu_price_cents, :integer, default: 0, null: false
  end
end
