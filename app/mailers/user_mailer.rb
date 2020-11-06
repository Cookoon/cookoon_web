class UserMailer < ApplicationMailer
  include MoneyRails::ActionViewExtension
  helper :datetime

  def welcome_email(user)
    @user = user
    mail(to: @user.full_email, subject: 'Bienvenue dans la communauté Cookoon')
  end

  def membership_asking_email(user)
    @user = user
    mail(to: @user.full_email, subject: "Cookoon : votre demande d'adhésion")
  end

  # def notify_invitations_awarded(user, invitation_quantity, message)
  #   @user = user
  #   @invitation_quantity = invitation_quantity
  #   @message = message
  #   mail(to: @user.full_email, subject: t('.subject', count: @invitation_quantity))
  # end

  # def notify_two_days_after_join(user)
  #   @user = user
  #   mail(to: @user.full_email, subject: 'Vous êtes membre de Cookoon ? Devenez Hôte')
  # end

  # def notify_five_days_after_invite(user, token)
  #   @user = user
  #   @token = token
  #   mail(to: @user.full_email, subject: "Vous n'avez pas encore accepté l'invitation de #{@user&.invited_by&.full_name} ?")
  # end

  # def notify_ten_days_after_invite(user, token)
  #   @user = user
  #   @token = token
  #   mail(to: @user.full_email, subject: "Cookoon : l'invitation de #{@user&.invited_by&.full_name} expire dans quelques jours")
  # end

  # def notify_six_days_after_reservation(user)
  #   @user = user
  #   mail(to: @user.full_email, subject: 'Et si vous louiez un nouveau Cookoon ?')
  # end

  # def notify_cookoon_pending_for_missing_stripe_account(user)
  #   @user = user
  #   mail(to: @user.full_email, subject: 'Renseignez vite vos informations bancaires pour recevoir vos paiements Cookoon !')
  # end
end
