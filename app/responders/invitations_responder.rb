module InvitationsResponder
  def to_html
    controller.flash[:invitation_sent] = true if post? && !has_errors?
    controller.flash[:invitation_accepted] = true if patch? && !has_errors?
    super
  end
end
