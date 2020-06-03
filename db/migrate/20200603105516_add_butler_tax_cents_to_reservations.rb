class AddButlerTaxCentsToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :butler_tax_cents, :integer, default: 0, null: false
  end
end
