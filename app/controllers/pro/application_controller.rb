module Pro
  class ApplicationController < ::ApplicationController
    before_action :verify_pro_user

    layout 'pro'

    private

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from User::NotProError, with: :user_not_pro

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé à réaliser cette action"
      redirect_to(pro_root_path)
    end

    def user_not_pro
      flash[:alert] = 'Cet espace est réservé aux professionnels'
      redirect_to(root_path)
    end

    def verify_pro_user
      raise User::NotProError unless current_user.pro?
    end
  end
end
