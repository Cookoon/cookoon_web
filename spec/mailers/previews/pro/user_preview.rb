module Pro
  class UserPreview < ActionMailer::Preview
    def invitation_instructions
      UserMailer.invitation_instructions(User.last, 'faketoken')
    end
  end
end
