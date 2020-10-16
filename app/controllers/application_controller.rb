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

  before_action :redirect_user, if: :redirect_user_needed?

  # Devise
  def is_flashing_format?
    controller_name.in? %w[invitations passwords]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[first_name last_name])
  end

  private

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à réaliser cette action"
    redirect_to(root_path)
  end

  def set_device
    @device = case request.user_agent
              when /Cookoon Inside iOS/
                :ios_inside
              when /Cookoon Inside Android/
                :android_inside
              when /iP(?:hone|od|ad)/
                :ios_browser
              when /Android/
                :android_browser
              else
                :desktop
              end
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(pages$)/
  end

  def redirect_user_needed?
    terms_of_service_acceptance_needed? || inscription_payment_needed?
  end

  def terms_of_service_acceptance_needed?
    true_user.terms_of_service_at.blank? || (true_user.terms_of_service.present? && true_user.terms_of_service_at < DateTime.new(2020, 9, 30, 14, 00, 00))
  end

  def inscription_payment_needed?
    true_user.inscription_payment_required?
  end

  def skip_general_conditions_validation?
    devise_controller? || (params[:controller] == "pages" && params[:action] == "general_conditions") || (params[:controller] == "users" && (params[:action] == "edit_general_conditions_acceptance" || params[:action] == "update_general_conditions_acceptance"))
  end

  def skip_inscription_payment?
    devise_controller? || params[:controller] == "inscription_payments"
  end

  def redirect_user
    if terms_of_service_acceptance_needed?
      redirect_to(edit_general_conditions_acceptance_users_path) unless skip_general_conditions_validation?
    elsif inscription_payment_needed?
      redirect_to(new_inscription_payment_path) unless skip_inscription_payment?
    end
  end
end
