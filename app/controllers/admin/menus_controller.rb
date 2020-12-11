module Admin
  class MenusController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_chef, only: %i[show new create edit update validate_menu archive_menu]
    before_action :find_menu, only: %i[show edit update validate_menu archive_menu]

    def show
      @dishes = @menu.dishes.order(order: :asc)
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
      end
    end

    def edit
    end

    def update
      if @menu.update(menu_params) #@menu.update(menu_title_params)
        redirect_to admin_chef_path(@chef), notice: 'Le menu a bien été modifié !'
      else
        render :edit
        # redirect_to admin_chef_path(@chef), alert: @menu.errors.messages
      end
    end

    def validate_menu
      if ((@menu.standing? && @chef.reached_max_active_menus_count?("standing_meal")) || (@menu.seated? && @chef.reached_max_active_menus_count?("seated_meal")))
        @menu.errors.messages[:status] = "2 menus actifs max en format debout par chef / 2 menus actifs max en format assis par chef. Archivez des menus"
        redirect_to admin_chef_path(@chef), alert: @menu.errors.messages
        # render 'admin/chefs/show', anchor: "menu-id-#{@menu.id}"
      else
        if @menu.update(status: "active")
          redirect_to admin_chef_path(@chef), notice: 'Le statut du menu est maintenant actif !'
        else
          redirect_to admin_chef_path(@chef), alert: @menu.errors.messages
        end
      end
    end

    def archive_menu
      if @menu.update(status: "archived")
        redirect_to admin_chef_path(@chef), notice: 'Le statut du menu est maintenant archivé !'
      else
        redirect_to admin_chef_path(@chef), alert: @menu.errors.messages
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
      authorize @menu, policy_class: Admin::MenuPolicy
    end

    def menu_params
      params.require(:menu).permit(:description, :unit_price, :meal_type)
    end

    def menu_title_params
      params.require(:menu).permit(:description)
    end

  end
end
