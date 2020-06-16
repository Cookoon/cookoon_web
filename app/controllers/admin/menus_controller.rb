module Admin
  class MenusController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_chef, only: %i[show new create edit update]
    before_action :find_menu, only: %i[edit update]

    def show
      @menu = Menu.find(params[:id])
      authorize @menu, policy_class: Admin::MenuPolicy
      @dishes = Dish.where(menu: @menu).order(order: :asc)
      @dish = Dish.new(menu: @menu)
      # authorize @dish, policy_class: Admin::DishPolicy
    end

    def new
      @menu = Menu.new(chef: @chef)
      authorize @menu, policy_class: Admin::MenuPolicy
    end

    def create
      @menu = Menu.new(menu_params)
      authorize @menu, policy_class: Admin::MenuPolicy
      @menu.chef = @chef
      if @menu.save
        redirect_to admin_chef_menu_path(@chef, @menu), notice: 'Le menu a bien été créé ! Ajoutez les plats'
      else
        render :new
        # redirect_to new_admin_chef_menu_path(@chef), alert: @menu.errors.full_messages
      end
    end

    def edit
    end

    def update
      if @menu.update(menu_params)
        redirect_to admin_chef_menu_path(@chef, @menu), notice: 'Le menu a bien été modifié ! Modifiez les plats'
      else
        render :edit
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
      @menu = Menu.find(params[:id])
      authorize @menu, policy_class: Admin::ChefPolicy
    end

    def menu_params
      params.require(:menu).permit(
        :description, :unit_price, :status
      )
    end

  end
end
