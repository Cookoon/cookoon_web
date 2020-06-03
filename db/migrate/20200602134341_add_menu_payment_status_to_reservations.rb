class AddMenuPaymentStatusToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :menu_payment_status, :string, default: "initial", null: false
  end
end
