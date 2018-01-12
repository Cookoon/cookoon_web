class Users::PasswordsController < Devise::PasswordsController
  respond_to :html, :js

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    super do |resource|
      if successfully_sent?(resource)
        return respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name)) do |format|
          format.js { redirect_to after_sending_reset_password_instructions_path_for(resource_name) }
        end
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super do |resource|
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message!(:notice, flash_message)
          sign_in(resource_name, resource)
        else
          set_flash_message!(:notice, :updated_not_active)
        end
        return respond_with resource, location: after_resetting_password_path_for(resource) do |format|
          format.js { redirect_to after_resetting_password_path_for(resource) }
        end
      end
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
