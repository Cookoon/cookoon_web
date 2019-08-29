class RemovePricesFromReservation < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :price_cents, :integer
    remove_column :reservations, :price_currency, :string
    remove_column :reservations, :status, :integer, default: 0
    remove_column :reservations, :cleaning, :boolean, default: false
    remove_column :reservations, :janitor, :boolean, default: false
    remove_column :reservations, :cookoon_fee_cents, :integer, default: 0, null: false
    remove_column :reservations, :cookoon_fee_tax_cents, :integer, default: 0, null: false
    remove_column :reservations, :services_tax_cents, :integer, default: 0, null: false
    remove_column :reservations, :services_full_price_cents, :integer, default: 0, null: false
    remove_column :reservations, :total_tax_cents, :integer, default: 0, null: false
    remove_column :reservations, :total_full_price_cents, :integer, default: 0, null: false
  end
end
