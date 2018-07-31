module Pro
  class CookoonsController < ApplicationController
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def index
      @cookoons = Cookoon.includes(:photo_files).decorate.first(5)
    end

    def show
      @cookoon = Cookoon.find(params[:id])
      @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
    end
  end
end
