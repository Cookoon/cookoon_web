module Admin
  class ChefsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_chef, only: %i[show edit update]

    def index
      @chefs = policy_scope([:admin, Chef]).includes(:photo_files)
    end

    def show
      @menu = Menu.new(chef: @chef)
    end

    def new
      @chef = Chef.new
      authorize @chef, policy_class: Admin::ChefPolicy
    end

    def create
      @chef = Chef.new(chef_params)
      authorize @chef, policy_class: Admin::ChefPolicy
      if @chef.save
        redirect_to new_admin_chef_menu_path(@chef), notice: 'Le Chef a été créé ! Ajoutez un menu'
      else
        render :new, alert: 'il y eu un problème, veuillez réessayer'
      end
    end

    def edit
    end

    def update
      # raise
      if @chef.update(chef_params)
        redirect_to admin_chef_path(@chef), notice: 'Le Chef a été édité !'
      else
        render :edit
      end
    end

    private

    # def require_admin
    #   current_user.admin == true
    # end

    def find_chef
      @chef = Chef.find(params[:id])
      authorize @chef, policy_class: Admin::ChefPolicy
    end

    def chef_params
      params.require(:chef).permit(
        :name, :description, :min_price, :base_price, photos: []
      )
    end

  end
end
