class NotifyReservationOneDayWithoutAnswerJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.needs_host_action.created_in_day_range_around(scheduled_date_time.ago(15.minutes)).each do |reservation|
      ReservationMailer.notify_awaiting_request_to_host(reservation).deliver_later
      Slack::UrgencyNotifier.new(reservation: reservation).notify
    end
  end
end
