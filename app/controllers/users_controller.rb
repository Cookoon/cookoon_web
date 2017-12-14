class UsersController < ApplicationController
  before_action :build_user, only: %i[edit update]
  before_action :require_admin!, only: %i[index impersonate stop_impersonating]

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Profil mis à jour'
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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :photo, :description)
  end

  def build_user
    @user = current_user
    authorize @user
  end

  def require_admin!
    raise Pundit::NotAuthorizedError unless true_user.admin?
  end
end
