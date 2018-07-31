module Pro
  class CookoonsController < ApplicationController
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def index
      @cookoons = Cookoon.includes(:photo_files).decorate.first(5)
    end
  end
end
