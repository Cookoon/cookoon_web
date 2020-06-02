class AddServicesPaymentStatusToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :services_payment_status, :string, default: "initial", null: false
  end
end
