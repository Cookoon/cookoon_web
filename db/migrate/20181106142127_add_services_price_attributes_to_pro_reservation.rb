class AddServicesPriceAttributesToProReservation < ActiveRecord::Migration[5.2]
  def change
    add_monetize :pro_reservations, :services_price_with_fee
    add_monetize :pro_reservations, :services_price_full
    rename_column :pro_reservations, :services_price_cents, :services_price_without_tax_and_fee_cents
    rename_column :pro_reservations, :services_price_currency, :services_price_without_tax_and_fee_currency
  end
end
