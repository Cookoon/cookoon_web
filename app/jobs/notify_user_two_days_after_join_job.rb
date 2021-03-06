class NotifyUserTwoDaysAfterJoinJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    User.has_no_cookoon.joined_in_day_range_around(scheduled_date_time.ago(7.days)).each do |user|
      UserMailer.notify_two_days_after_join(user).deliver_later
    end
  end
end
