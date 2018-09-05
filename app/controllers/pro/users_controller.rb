module Pro
  class UsersController < ApplicationController
    before_action :set_user, only: %i[edit update]

    def edit
    end

    def update
    end

    private

    def set_user
      @user = current_user
      authorize @user
    end
  end
end
