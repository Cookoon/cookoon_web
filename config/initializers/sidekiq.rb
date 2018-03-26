class Cookoon::NonRetriableJobs
  def call(worker, msg, queue)
    yield
  rescue Postmark::InvalidMessageError
    msg['retry'] = false
    raise
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Cookoon::NonRetriableJobs
  end
end
