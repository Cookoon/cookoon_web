class PingSlackReservationOneDayWithoutAnswerJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.needs_host_action.created_in_day_range_around(scheduled_date_time.ago(1.hours)).each do |reservation|
      service = Slack::UrgencyNotifier.new(reservation: reservation)
      service.notify
    end
  end
end
