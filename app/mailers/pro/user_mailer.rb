module Pro
  class UserMailer < ApplicationMailer
    def invitation_instructions(user, token)
      @user = user
      @token = token
      mail(to: @user.full_email, subject: 'Vous avez été invité à rejoindre Cookoon')
    end
  end
end
