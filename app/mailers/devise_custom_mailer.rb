class DeviseCustomMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def invitation_instructions(record, token, opts={})
    opts[:subject] = "#{record&.invited_by.full_name} vous a invité a rejoindre Cookoon !"
    super
  end
end
