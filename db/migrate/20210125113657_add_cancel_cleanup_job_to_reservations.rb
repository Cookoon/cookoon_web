class AddCancelCleanupJobToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :cancel_cleanup_job, :boolean
  end
end
