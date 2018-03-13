class DeviseCustomMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  helper :branch_url

  def invitation_instructions(record, token, opts = {})
    opts[:subject] = t(
      'devise.mailer.invitation_instructions.subject',
      inviter: record&.invited_by&.full_name
    )
    super
  end
end
