class AddTiedToReservationToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :payment_tied_to_reservation, :boolean, default: false
  end
end
