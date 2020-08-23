class AddStripeMenuIdToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :stripe_menu_id, :string
  end
end
