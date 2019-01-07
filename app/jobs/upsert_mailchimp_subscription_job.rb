class UpsertMailchimpSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(email, mailchimp_list_id, body = {})
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    gibbon.lists(mailchimp_list_id)
          .members(Digest::MD5.hexdigest(email.downcase))
          .upsert(body: body)
  end
end
