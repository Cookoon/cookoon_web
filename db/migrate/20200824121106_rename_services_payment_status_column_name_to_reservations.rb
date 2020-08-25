class RenameServicesPaymentStatusColumnNameToReservations < ActiveRecord::Migration[5.2]
  def change
    rename_column :reservations, :services_payment_status, :services_status
  end
end
