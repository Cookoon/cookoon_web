class Users::InvitationsController < Devise::InvitationsController
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    respond_with_navigational(resource) { render :new } unless resource_invited

    redirect_to cookoons_path, flash: { invitation_sent: true }
  end

  private

  def after_accept_path_for(resource)
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
