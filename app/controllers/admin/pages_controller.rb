module Admin
  class PagesController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin

    def dashboard
    end

    # private

    # def require_admin
    #   current_user.admin == true
    # end

  end
end
