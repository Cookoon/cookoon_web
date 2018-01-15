class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.full_email, subject: 'Bienvenue dans la communauté Cookoon !')
  end

  def notify_invitations_awarded(user, invitation_quantity)
    @user = user
    @invitation_quantity = invitation_quantity
    mail(to: @user.full_email, subject: "Nous venons de vous offrir #{invitation_quantity} invitations")
  end
end
