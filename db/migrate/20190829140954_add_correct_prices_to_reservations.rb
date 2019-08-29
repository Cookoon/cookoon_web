class AddCorrectPricesToReservations < ActiveRecord::Migration[5.2]
  def change
    add_monetize :reservations, :services_tax, currency: { present: false }
    add_monetize :reservations, :services_with_tax, currency: { present: false }
    add_monetize :reservations, :total_tax, currency: { present: false }
    add_monetize :reservations, :total_with_tax, currency: { present: false }
  end
end
