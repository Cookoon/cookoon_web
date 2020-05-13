module Admin
  class ChefsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    # before_action :find_chef, only: %i[show]

    def index
      @chefs = policy_scope([:admin, Chef]).includes(:menus)
    end

    # def show
    # end

    private

    # def find_chef
    # end

  end
end
