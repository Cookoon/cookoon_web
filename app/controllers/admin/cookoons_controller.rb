module Admin
  class CookoonsController < ApplicationController
    before_action :require_admin

    def index
      @cookoons = Cookoon.all
    end

    def edit
      @cookoon = Cookoon.find(params[:id])
    end

    def update
      @cookoon = Cookoon.find(params[:id])
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

    def require_admin
      current_user.admin == true
    end

  end
end
