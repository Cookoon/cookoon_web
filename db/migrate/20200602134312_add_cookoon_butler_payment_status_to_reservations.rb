class AddCookoonButlerPaymentStatusToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :cookoon_butler_payment_status, :string, default: "initial", null: false
  end
end
