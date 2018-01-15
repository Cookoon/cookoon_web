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

  def notify_two_days_after_join(user)
    @user = user
    mail(to: @user.full_email, subject: 'Vous êtes membre de Cookoon ? Devenez Hôte !')
  end

  def notify_five_days_after_invite(user, token)
    @user = user
    @token = token
    mail(to: @user.full_email, subject: 'Vous n’avez pas encore rejoint Cookoon ?')
  end

  def notify_ten_days_after_invite(user, token)
    @user = user
    @token = token
    mail(to: @user.full_email, subject: 'Dernière chance pour rejoindre Cookoon !')
  end
end
