module Devise
  class MailerPreview < ActionMailer::Preview
    def invitation_instructions
      Devise::Mailer.invitation_instructions(User.first, 'faketoken')
    end
  end
end
