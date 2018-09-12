module Pro
  class UserMailer < ApplicationMailer
    def invitation_instructions(user, token)
      @user = user
      @token = token
      mail(to: @user.full_email, subject: 'Votre invitation pro')
    end
  end
end
