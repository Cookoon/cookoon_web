module Devise
  class MailerPreview < ActionMailer::Preview
    def invitation_instructions
      DeviseCustomMailer.invitation_instructions(User.last, 'faketoken')
    end

    def reset_password_instructions
      DeviseCustomMailer.reset_password_instructions(User.first, 'faketoken')
    end
  end
end
