class UsersController < ApplicationController
  before_action :build_user, only: %i[edit update]
  before_action :require_admin!, only: %i[index impersonate stop_impersonating]
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    @user = User.new(special_offer: params["special-offer"])
    @job = @user.build_job
    @personal_taste = @user.build_personal_taste
    @motivation = @user.build_motivation
  end

  def create
    @user = User.new(new_user_params)
    @user.special_offer = params[:user][:special_offer]
    @user.assign_attributes(membership_asking: true, skip_password_validation: true)

    @job = @user.build_job(job_params)
    @personal_taste = @user.build_personal_taste(personal_taste_params)
    @motivation = @user.build_motivation(motivation_params)

    if @user.save
      @user.send_membership_asking_email
      flash[:notice] = "Votre demande d'adhésion nous a été transmise, nous reviendrons vers vous après avoir étudié votre candidature."
      redirect_to new_user_session_path
    else
      if @user.errors.messages[:special_offer].present?
        flash.now.alert = "L'url de la page que vous avez renseignée semble incorrecte. Veuillez la vérifier pour finaliser votre demande."
        render :new, special_offer: @user.special_offer
      else
        render :new
      end
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Votre profil a été mis à jour'
      redirect_to root_path
    else
      render :edit
    end
  end

  def index
    @users = policy_scope(User).order(:id)
  end

  def impersonate
    authorize true_user
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    authorize true_user
    stop_impersonating_user
    redirect_to root_path
  end

  def edit_general_conditions_acceptance
    authorize true_user
    @date_time_now = Time.zone.now
  end

  def update_general_conditions_acceptance
    authorize true_user
    @date_time_now = Time.zone.now
    if current_user.update(user_params_for_general_conditions)
      redirect_to home_path
    else
      flash[:alert] = current_user.errors.messages.values.join(", ")
      redirect_to edit_general_conditions_acceptance_users_path
    end
  end

  private

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :born_on, :phone_number, :photo, :description, :address, :special_offer)
  end

  def job_params
    params.require(:job).permit(:job_title, :company, :linkedin_profile)
  end

  def personal_taste_params
    params.require(:personal_taste).permit(:favorite_wines, :favorite_restaurants)
  end

  def motivation_params
    params.require(:motivation).permit(:content)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :born_on, :phone_number, :photo, :description, :address)
  end

  def build_user
    @user = current_user
    authorize @user
  end

  def require_admin!
    raise Pundit::NotAuthorizedError unless true_user.admin?
  end

  def user_params_for_general_conditions
    params.require(:user).permit(:terms_of_service, :terms_of_service_at)
  end
end
