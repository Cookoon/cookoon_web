module Pro
  module Reservations
    class CookoonsController < ApplicationController
      def show
        @cookoon = Cookoon.find(params[:id])
        authorize @cookoon

        @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
      end
    end
  end
end
