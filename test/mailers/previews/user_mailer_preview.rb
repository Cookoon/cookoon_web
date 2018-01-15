class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.last)
  end

  def notify_invitations_awarded
    UserMailer.notify_invitations_awarded(User.last, 5)
  end

  def notify_two_days_after_join
    UserMailer.notify_two_days_after_join(User.last)
  end

  def notify_five_days_after_invite
    UserMailer.notify_five_days_after_invite(User.last, 'fakeToken')
  end

  def notify_ten_days_after_invite
    UserMailer.notify_ten_days_after_invite(User.last, 'fakeToken')
  end
end
