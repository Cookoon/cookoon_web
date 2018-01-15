class Users::InvitationsController < Devise::InvitationsController
  responders :invitations

  private

  def after_accept_path_for(_resource)
    edit_users_path
  end

  def update_resource_params
    params.require(:user).permit(
      :invitation_token,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :phone_number,
      :terms_of_service
    )
  end
end
