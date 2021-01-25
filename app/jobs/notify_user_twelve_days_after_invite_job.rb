class NotifyUserTwelveDaysAfterInviteJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    User.all_emails.invited_in_day_range_around(scheduled_date_time.ago(12.days)).each do |user|
      user.invite! { |u| u.skip_invitation = true }
      new_token = user.raw_invitation_token
      UserMailer.notify_twelve_days_after_invite(user, new_token).deliver_later
    end
  end
end
