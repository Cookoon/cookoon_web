class AddCookoonButlerWithTaxCentsToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :cookoon_butler_with_tax_cents, :integer, default: 0, null: false
  end
end
