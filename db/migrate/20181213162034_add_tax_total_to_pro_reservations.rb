class AddTaxTotalToProReservations < ActiveRecord::Migration[5.2]
  def change
    add_monetize :pro_reservations, :tax_total
  end
end
