class Users::InvitationsController < Devise::InvitationsController
  private

  def update_resource_params
    params.require(:user).permit(
      :invitation_token,
      :password,
      :password_confirmation,
      :terms_of_service
    )
  end
end
