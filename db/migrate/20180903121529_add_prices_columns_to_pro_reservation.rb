class AddPricesColumnsToProReservation < ActiveRecord::Migration[5.2]
  def change
    rename_column :pro_reservations, :fee_cents, :cookoon_fee_cents
    rename_column :pro_reservations, :fee_currency, :cookoon_fee_currency
    add_monetize :pro_reservations, :cookoon_fee_tax
    add_monetize :pro_reservations, :services_fee
    add_monetize :pro_reservations, :services_tax
    add_monetize :pro_reservations, :price_excluding_tax
  end
end
