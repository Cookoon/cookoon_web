class AddStripeServicesIdToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :stripe_services_id, :string
  end
end
