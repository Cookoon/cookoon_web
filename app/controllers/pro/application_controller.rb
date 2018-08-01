module Pro
  class ApplicationController < ::ApplicationController
    before_action :verify_pro_user

    layout 'pro'

    private

    def verify_pro_user
      raise Pundit::NotAuthorizedError unless current_user.pro?
    end
  end
end
