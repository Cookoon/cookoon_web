class NotifyCookoonPendingForMissingStripeAccountJob < ApplicationJob
  queue_as :default

  def perform(scheduled_time)
    scheduled_date_time = Time.zone.at(scheduled_time)
    users = User.with_cookoon_created_in_day_range_around(scheduled_date_time.ago(5.days)).missing_stripe_account

    users.each do |user|
      # UserMailer.notify_cookoon_pending_for_missing_stripe_account(user).deliver_later
    end
  end
end
