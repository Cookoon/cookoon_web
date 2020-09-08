class NotifyUserSevenDaysAfterAcceptJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    # User.all_emails.invited_in_day_range_around(scheduled_date_time.ago(7.days)).each do |user|
    User.all_emails.invited_in_day_range_around(scheduled_date_time.ago(1.hours)).each do |user|
      user.invite! { |u| u.skip_invitation = false }
      UserMailer.notify_user_seven_days_after_accept(user).deliver_later
    end
  end
end
