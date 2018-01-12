class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.last)
  end

  def notify_invitations_awarded
    UserMailer.notify_invitations_awarded(User.last, 5)
  end
end
