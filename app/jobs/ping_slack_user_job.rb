class PingSlackUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    service = Slack::UserNotifier.new(user: user)
    service.notify
  end
end
