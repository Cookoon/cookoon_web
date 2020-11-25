class PingSlackInscriptionPaymentJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    service = Slack::InscriptionPaymentNotifier.new(user: user)
    service.notify
  end
end
