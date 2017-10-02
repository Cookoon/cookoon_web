class UsersController < ApplicationController
  before_action :build_user, only: [:edit, :update]
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profil mis à jour"
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :photo, :description)
  end

  def build_user
    @user = current_user
    authorize @user
  end
end
