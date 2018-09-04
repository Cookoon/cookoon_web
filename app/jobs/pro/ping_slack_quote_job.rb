class PingSlackQuoteJob < ApplicationJob
  queue_as :default

  def perform(quote_id)
    quote = Quote.find(quote_id)
    service = Slack::QuoteNotifier.new(quote: quote)
    service.notify
  end
end
