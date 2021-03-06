class NotifyReservationOneDayWithoutHostAnswerJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_hour_time = Time.zone.at(scheduled_time)
    Reservation.needs_host_action.created_in_hour_range_around(scheduled_hour_time.ago(25.hours)).each do |reservation|
      ReservationMailer.notify_awaiting_request_to_host(reservation).deliver_later
      # Slack::ReservationOneDayWithoutHostAnswerNotifier.new(reservation: reservation).notify
    end
  end
end
