module Admin
  class DishesController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_chef, only: %i[create destroy]
    before_action :find_menu, only: %i[create destroy]
    before_action :find_dish, only: %i[destroy]

    def create
      @dish = Dish.new(dish_params)
      authorize @dish, policy_class: Admin::DishPolicy
      @dish.menu = @menu
      if @dish.save
        # redirect_to admin_chef_menu_dish_path(@chef, @menu, @dish), notice: 'Le plat a bien été ajouté !'
        respond_to do |format|
          format.html { redirect_to admin_chef_menu_path(@chef, @menu), notice: 'Le plat a bien été ajouté !' }
          format.js  # <-- will render `app/views/admin/dishes/create.js.erb`
        end
      else
        respond_to do |format|
          format.html { render "admin/dishes/show" }
          format.js  # <-- will render `app/views/admin/dishes/create.js.erb`
        end
        # render "admin/dishes/show"
        # rails routes
        # admin_chef_menu GET /admin/chefs/:chef_id/menus/:id(.:format) admin/menus#show
        # take admin/menus#show and replace # by /
      end
    end

    def destroy
      if @dish.destroy
        respond_to do |format|
          format.html { redirect_to admin_chef_menu_path(@chef, @menu), notice: 'Le plat a bien été supprimé !' }
          format.js  # <-- will render `app/views/admin/dishes/destroy.js.erb`
        end
      end
    end

    private

    # def require_admin
    #   current_user.admin == true
    # end

    def find_chef
      @chef = Chef.find(params[:chef_id])
    end

    def find_menu
      @menu = Menu.find(params[:menu_id])
    end

    def find_dish
      @dish = Dish.find(params[:id])
      authorize @dish, policy_class: Admin::DishPolicy
    end

    def dish_params
      params.require(:dish).permit(
        :order, :category, :name
      )
    end

  end
end
