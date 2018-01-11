class NotifyReservationInThreeHoursJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.in_hour_range_around(scheduled_date_time.since(3.hours)).each do |reservation|
      ReservationMailer.notify_tenant_before_reservation(reservation).deliver_later
    end
  end
end
