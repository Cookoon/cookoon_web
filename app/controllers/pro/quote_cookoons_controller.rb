module Pro
  class QuoteCookoonsController < ApplicationController
    # TODO, CP 2aug : Replace with actual policies
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def create
      @quote = Quote.includes(:cookoons).find(params[:quote_id])
      @cookoon = Cookoon.find(params[:cookoon_id])
      @quote.quote_cookoons.create(cookoon: @cookoon)
      @quote.reload
      return redirect_to pro_quote_services_path(@quote) if @quote.cookoons.count == 2
    end

    # TODO, CP 2aug : Will we use this ?
    def update; end

    private

    def quote_params
      params.require(:pro_quote).permit(:start_at, :duration, :people_count)
    end
  end
end
