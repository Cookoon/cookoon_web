module Admin
  class CookoonsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_cookoon, only: %i[edit update]

    def index
      @cookoons_approved = cookoons.where(status: "approved")
      @cookoons_suspended = cookoons.where(status: "suspended")
      @cookoons_under_review = cookoons.where(status: "under_review")
    end

    def edit
      @perks_selected = @cookoon.perks.includes(:perk_specification)
      # @perks_available = PerkSpecification.where.not(name: @perks_selected).pluck(:name, :icon_name)
      @perks_not_selected = PerkSpecification.where.not(id: @cookoon.perks.pluck(:perk_specification_id))
    end

    def update
      if @cookoon.update(cookoon_params)
        redirect_to admin_cookoons_path, notice: 'Le Cookoon a été édité !'
      else
        render :edit
      end
    end

    private

    def cookoon_params
      params.require(:cookoon).permit(
        :name, :surface, :price, :address, :capacity, :category,
        :digicode, :building_number, :floor_number, :door_number,
        :wifi_network, :wifi_code, :caretaker_instructions, :status,
        :description, photos: []
      )
    end

    # def require_admin
    #   current_user.admin == true
    # end

    def find_cookoon
      @cookoon = Cookoon.find(params[:id]).decorate
      authorize @cookoon, policy_class: Admin::CookoonPolicy
    end

    def cookoons
      # policy_scope([:admin, Cookoon]).includes(:user, :perk_specifications)
      policy_scope([:admin, Cookoon]).includes(:user, :perks, :perk_specifications)
    end

  end
end
