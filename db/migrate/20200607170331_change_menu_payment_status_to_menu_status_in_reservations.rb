class ChangeMenuPaymentStatusToMenuStatusInReservations < ActiveRecord::Migration[5.2]
  def change
    change_table :reservations do |t|
      t.rename :menu_payment_status, :menu_status
    end
  end
end
