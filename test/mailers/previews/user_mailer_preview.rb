class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.last)
  end

  def notify_invitations_awarded
    UserMailer.notify_invitations_awarded(User.last, 5)
  end

  def notify_cookoon_pending_for_missing_stripe_account
    UserMailer.notify_cookoon_pending_for_missing_stripe_account(User.joins(:cookoons).last)
  end
end
