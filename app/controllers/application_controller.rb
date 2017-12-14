class ApplicationController < ActionController::Base
  include Pundit

  impersonates :user

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à réaliser cette action"
    redirect_to(root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name])
  end

  def current_search
    return unless current_user
    @current_search ||= current_user.last_recent_search
  end

  # disable devises flashes
  def is_flashing_format?
    false
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
