module Pro
  class CookoonsController < ApplicationController
    # TODO CP 31 JUL : Use actual pundit policies
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def index
      # TODO CP 31 JUL : Use quote to select cookoons
      @quote = Pro::Quote.find(params[:quote_id]).decorate
      @cookoons = Cookoon.includes(:photo_files).decorate.first(5)
    end

    def show
      @cookoon = Cookoon.find(params[:id])
      @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
    end
  end
end
