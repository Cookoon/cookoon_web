require 'turbolinks/redirection'

class ApplicationController < ActionController::Base
  include Pundit
  include TurbolinksCacheControl
  include Turbolinks::Redirection

  protect_from_forgery with: :exception, prepend: true
  impersonates :user

  before_action :authenticate_user!
  before_action :set_device
  before_action :amex?
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  before_action :redirect_user, if: :redirect_user_needed?

  # Devise
  def is_flashing_format?
    controller_name.in? %w[invitations passwords]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[first_name last_name inscription_payment_required])
  end

  def terms_of_service_acceptance_needed_for_true_user?
    terms_of_service_acceptance_needed?
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

  def namespace
    params[:controller].split("/").first
    # controller.class.parents.first == UnChefPourVous
    # controller_path.start_with? 'un_chef_pour_vous'
    # params[:controller].split("/").first == "un_chef_pour_vous"
  end

  def amex?
    namespace == "un_chef_pour_vous"
  end

  def new_user_asking?
    params[:controller] == "users" && (params[:action] == "new" || params[:action] == "create")
  end

  def user_answer_invitation?
    params[:controller] == "users/invitations" && (params[:action] == "edit" || params[:action] == "update")
  end

  def general_conditions?
    params[:controller] == "pages" && params[:action] == "general_conditions"
  end

  def general_conditions_validation?
    params[:controller] == "users" && (params[:action] == "edit_general_conditions_acceptance" || params[:action] == "update_general_conditions_acceptance")
  end

  def inscription_payment?
    params[:controller] == "inscription_payments" || params[:controller] == "credit_cards"
  end

  # def user_photo_adding?
  #   params[:controller] == "users" && (params[:action] == "edit" || params[:action] == "update")
  # end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(pages$)/ || new_user_asking? || amex?
  end

  def redirect_user_needed?
    if (devise_controller? || new_user_asking? || user_answer_invitation? || general_conditions? || amex?)
      false
    else
      terms_of_service_acceptance_needed? || inscription_payment_needed? #|| user_photo_needed?
    end
  end

  def terms_of_service_acceptance_needed?
    true_user.terms_of_service_at.blank? || (true_user.terms_of_service.present? && true_user.terms_of_service_at < User::TERMS_OF_SERVICE_DATE)
  end

  def inscription_payment_needed?
    true_user.inscription_payment_required?
  end

  # def user_photo_needed?
  #   !true_user.photo?
  # end

  def skip_general_conditions_validation?
    general_conditions? || general_conditions_validation?
  end

  def skip_inscription_payment?
    inscription_payment?
  end

  # def skip_user_photo_adding?
  #   user_photo_adding?
  # end

  def redirect_user
    if terms_of_service_acceptance_needed?
      redirect_to(edit_general_conditions_acceptance_users_path) unless skip_general_conditions_validation?
    elsif inscription_payment_needed?
      redirect_to(new_inscription_payment_path) unless skip_inscription_payment?
    # elsif user_photo_needed?
    #   unless skip_user_photo_adding?
    #     flash[:alert] = "Vous devez ajouter une photo."
    #     redirect_to(edit_users_path)
    #   end
    end
  end
end
