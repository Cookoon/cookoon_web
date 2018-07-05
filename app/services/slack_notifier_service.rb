class SlackNotifierService
  WEBHOOK_URL = 'https://hooks.slack.com/services/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'

  def initialize(attributes)
    @reservation = attributes[:reservation]
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
  end

  def notify
    notifier = Slack::Notifier.new WEBHOOK_URL, notifier_options
    notifier.ping message
  end

  private

  def notifier_options
    {
      channel: "#locations",
      username: "Nestor le concierge"
    }
  end

  def message
    "Hello random"
  end
end
