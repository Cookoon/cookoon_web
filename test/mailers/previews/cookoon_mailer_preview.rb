class CookoonMailerPreview < ActionMailer::Preview
  def notify_approved
    CookoonMailer.notify_approved(Cookoon.last)
  end
end
