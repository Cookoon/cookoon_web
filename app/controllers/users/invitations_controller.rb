class Users::InvitationsController < Devise::InvitationsController
  responders :invitations
  before_action :set_time_now, only: %i[edit update]

  def new
    if terms_of_service_acceptance_needed_for_true_user?
      redirect_to(edit_general_conditions_acceptance_users_path)
    else
      super
    end
  end

  private

  def after_accept_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def update_resource_params
    params.require(:user).permit(
      :photo,
      :invitation_token,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :phone_number,
      :born_on,
      :terms_of_service,
      :terms_of_service_at
    )
  end

  def set_time_now
    # @date_time_now = DateTime.now
    @date_time_now = Time.zone.now
  end
end
