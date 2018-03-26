class NotifyReservationOneDayWithoutAnswerJob < NotifierJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.paid.created_in_day_range_around(scheduled_date_time.ago(1.day)).each do |reservation|
      ReservationMailer.notify_awaiting_request_to_host(reservation).deliver_later
    end
  end
end
