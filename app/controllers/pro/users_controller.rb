module Pro
  class UsersController < ApplicationController
    before_action :set_user, only: %i[edit update]

    def edit
    end

    def update
      if @user.update(user_params)
        flash.notice = 'Votre profil a été mis à jour'
        bypass_sign_in current_user
        redirect_to edit_pro_user_path
      else
        flash.alert = "Votre profil n'a pas pu être sauvegardé"
        render :edit
      end
    end

    private

    def set_user
      @user = current_user
      authorize @user
    end

    def user_params
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
    end
  end
end
