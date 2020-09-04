class NotifyUserSixDaysAfterReservationJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    User.with_reservation_finished_in_day_range_around(scheduled_date_time.ago(6.days)).each do |user|
      # UserMailer.notify_six_days_after_reservation(user).deliver_later
    end
  end
end
