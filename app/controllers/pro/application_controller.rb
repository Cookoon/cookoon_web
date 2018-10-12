module Pro
  class ApplicationController < ::ApplicationController
    class MobileForbiddenError < StandardError; end

    before_action :verify_access

    layout 'pro'

    private

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from User::NotProError, with: :user_not_pro
    rescue_from MobileForbiddenError, with: :desktop_only

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé à réaliser cette action"
      redirect_to(pro_root_path)
    end

    def user_not_pro
      flash[:alert] = 'Cet espace est réservé aux professionnels'
      redirect_to(root_path)
    end

    def desktop_only
      flash[:alert] = 'Cet espace est accessible sur Desktop uniquement'
      redirect_to(root_path)
    end

    def verify_pro_user
      raise User::NotProError unless current_user.pro?
    end

    def restrict_to_desktop
      raise MobileForbiddenError unless @device == :desktop
    end

    def verify_access
      restrict_to_desktop
      verify_pro_user
    end
  end
end
