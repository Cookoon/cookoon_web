class Users::InvitationsController < Devise::InvitationsController
  private

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
