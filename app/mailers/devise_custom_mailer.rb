class DeviseCustomMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def invitation_instructions(record, token, opts = {})
    opts[:subject] = t(
      'devise.mailer.invitation_instructions.subject',
      inviter: record&.invited_by&.full_name
    )
    super
  end
end
