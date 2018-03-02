class PrepareSearchOnReservations < ActiveRecord::Migration[5.1]
  def change
    rename_column :reservations, :date, :start_at
    add_column :reservations, :end_at, :datetime
  end
end
