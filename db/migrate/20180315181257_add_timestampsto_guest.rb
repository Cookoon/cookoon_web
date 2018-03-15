class AddTimestampstoGuest < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:guests, null: true)
    Guest.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)
    change_column_null :guests, :created_at, false
    change_column_null :guests, :updated_at, false

    add_timestamps(:reservation_guests, null: true)
    ReservationGuest.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)
    change_column_null :reservation_guests, :created_at, false
    change_column_null :reservation_guests, :updated_at, false
  end
end
