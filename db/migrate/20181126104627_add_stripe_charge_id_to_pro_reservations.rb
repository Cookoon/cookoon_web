class AddStripeChargeIdToProReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :pro_reservations, :stripe_charge_id, :string
  end
end
