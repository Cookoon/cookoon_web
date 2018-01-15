class CookoonMailer < ApplicationMailer
  def notify_approved(cookoon)
    @cookoon = cookoon
    @user = @cookoon.user
    mail(to: @user.full_email, subject: 'Votre Cookoon est en ligne !')
  end
end
