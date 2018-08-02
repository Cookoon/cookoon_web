module Pro
  class CookoonsController < ApplicationController
    def index
      quote = Pro::Quote.find(params[:quote_id])
      @quote = quote.decorate

      filtering_params = {
        accomodates_for: quote.people_count,
        available_in: (quote.start_at..@quote.end_at)
      }
      @cookoons = policy_scope(Cookoon)
                  .includes(:photo_files)
                  .filter(filtering_params)
                  .decorate
    end

    def show
      @cookoon = Cookoon.find(params[:id])
      authorize @cookoon

      @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
    end
  end
end
