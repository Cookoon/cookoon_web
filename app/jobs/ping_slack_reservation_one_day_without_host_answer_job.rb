class PingSlackReservationOneDayWithoutHostAnswerJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_hour_time = Time.zone.at(scheduled_time)
    Reservation.needs_host_action.created_in_hour_range_around(scheduled_hour_time.ago(1.hour)).each do |reservation|
      Slack::ReservationOneDayWithoutHostAnswerNotifier.new(reservation: reservation).notify
    end
  end
end
