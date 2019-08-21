class AddPricesToReservations < ActiveRecord::Migration[5.2]
  def change
    add_monetize :reservations, :cookoon_price, currency: { present: false }
    add_monetize :reservations, :cookoon_fee, currency: { present: false }
    add_monetize :reservations, :cookoon_fee_tax, currency: { present: false }
    add_monetize :reservations, :services_price, currency: { present: false }
    add_monetize :reservations, :services_tax, currency: { present: false }
    add_monetize :reservations, :services_full_price, currency: { present: false }
    add_monetize :reservations, :total_tax, currency: { present: false }
    add_monetize :reservations, :total_price, currency: { present: false }
    add_monetize :reservations, :total_full_price, currency: { present: false }
  end
end
