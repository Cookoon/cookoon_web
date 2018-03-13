class NotifyReservationInThreeHoursJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.accepted.in_hour_range_around(scheduled_date_time.in(3.hours)).each do |reservation|
      ReservationMailer.notify_approaching_reservation_to_tenant(reservation).deliver_later
    end
  end
end
