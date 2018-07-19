class PingSlackHostJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    service = Slack::HostNotifier.new(user: user)
    service.notify
  end
end
