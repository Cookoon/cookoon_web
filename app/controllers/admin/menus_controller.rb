module Admin
  class MenusController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_chef, only: %i[create]

    def create
      @menu = Menu.new(menu_params)
      authorize @menu, policy_class: Admin::MenuPolicy
      @menu.chef = @chef
      if @menu.save
        redirect_to admin_chef_path(@chef), notice: 'Le menu a bien été créé !'
      else
        render 'admin/chefs/show'
        # render "admin/chefs/#{params[:chef_id]}/menus#new_menu"
        # redirect_to admin_chef_path(@chef, anchor: "new_menu")
      end
    end

    # def update
    #   if @chef.update(chef_params)
    #     redirect_to admin_chef_path(@chef), notice: 'Le Cookoon a été édité !'
    #   else
    #     render :edit
    #   end
    # end

    private

    # def require_admin
    #   current_user.admin == true
    # end

    def find_chef
      @chef = Chef.find(params[:chef_id])
      authorize @chef, policy_class: Admin::ChefPolicy
    end

    def menu_params
      params.require(:menu).permit(
        :description, :unit_price
      )
    end

  end
end
