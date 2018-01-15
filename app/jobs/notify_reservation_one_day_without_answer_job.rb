class NotifyReservationOneDayWithoutAnswerJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    Reservation.created_in_day_range_around(scheduled_date_time.ago(1.days)).paid.each do |reservation|
      ReservationMailer.waiting_host_answer_for_one_day(reservation).deliver_later
    end
  end
end
