module Slack
  class BaseNotifier
    def notify
      return unless message
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'], notifier_options
      notifier.ping message
    end

    private

    attr_reader :user

    def notifier_options
      {
        channel: @channel || '#general',
        username: 'Nestor le concierge'
      }
    end

    def message
      Rails.logger.error('This method : BaseNotifier#message should not be called !')
      false
    end
  end
end
