class UpsertMailchimpSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(email, mailchimp_list_id, merge_fields = {})
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    gibbon.lists(mailchimp_list_id)
          .members(Digest::MD5.hexdigest(email.downcase))
          .upsert(
            body: {
              email_address: email,
              status: 'subscribed',
              merge_fields: merge_fields
            }
          )
  end
end
