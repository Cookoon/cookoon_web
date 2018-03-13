require 'turbolinks/redirection'

class ApplicationController < ActionController::Base
  include Pundit
  include TurbolinksCacheControl
  include Turbolinks::Redirection

  protect_from_forgery with: :exception, prepend: true
  impersonates :user

  before_action :authenticate_user!
  before_action :set_device
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à réaliser cette action"
    redirect_to(root_path)
  end

  # Devise
  def is_flashing_format?
    controller_name.in? %w(invitations passwords)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name])
  end

  private

  def set_device
    @device = case request.user_agent
              when /Cookoon Inside iOS/
                :ios_inside
              when /Cookoon Inside Android/
                :android_inside
              ##################################################################
              # TODO: FC 13mar18 remove this section when all installed apps are
              # at least version 1.4.1 (includes 'Cookoon Inside' user agent)
              when /iP(?:hone|od|ad).*AppleWebKit(?!.*(?:Version|CriOS))/i
                :ios_inside
              when /Android(?:.*; wv)/i
                :android_inside
              ##################################################################
              when /iP(?:hone|od|ad)/
                :ios_browser
              when /Android/
                :android_browser
              else
                :desktop
              end
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
