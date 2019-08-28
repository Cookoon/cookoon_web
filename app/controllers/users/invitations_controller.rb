class Users::InvitationsController < Devise::InvitationsController
  responders :invitations

  private

  def after_accept_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def update_resource_params
    params.require(:user).permit(
      :invitation_token,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :phone_number,
      :born_on,
      :terms_of_service
    )
  end
end
