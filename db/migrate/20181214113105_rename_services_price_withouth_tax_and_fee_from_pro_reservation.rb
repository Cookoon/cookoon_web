class RenameServicesPriceWithouthTaxAndFeeFromProReservation < ActiveRecord::Migration[5.2]
  def change
    remove_column :pro_reservations, :cookoon_price_currency, :integer
    remove_column :pro_reservations, :services_price_without_tax_and_fee_currency, :integer
    remove_column :pro_reservations, :cookoon_fee_currency, :integer
    remove_column :pro_reservations, :price_currency, :integer
    remove_column :pro_reservations, :cookoon_fee_tax_currency, :integer
    remove_column :pro_reservations, :services_fee_currency, :integer
    remove_column :pro_reservations, :services_fee_cents, :integer
    remove_column :pro_reservations, :services_tax_currency, :integer
    remove_column :pro_reservations, :price_excluding_tax_currency, :integer
    remove_column :pro_reservations, :services_price_with_fee_currency, :integer
    remove_column :pro_reservations, :services_price_full_currency, :integer
    remove_column :pro_reservations, :tax_total_currency, :integer
    remove_column :pro_reservations, :services_price_with_fee_cents, :integer

    rename_column :pro_reservations, :services_price_without_tax_and_fee_cents, :services_price_cents
    rename_column :pro_reservations, :services_price_full_cents, :services_full_price_cents
    rename_column :pro_reservations, :price_excluding_tax_cents, :total_price_cents
    rename_column :pro_reservations, :tax_total_cents, :total_tax_cents
    rename_column :pro_reservations, :price_cents, :total_full_price_cents
  end
end
