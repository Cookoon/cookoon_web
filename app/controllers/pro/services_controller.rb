module Pro
  class ServicesController < ApplicationController
    # TODO FC 02 AUG : Use actual pundit policies
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def index
      @quote = Quote.find(params[:quote_id]).decorate

      # TODO FC 02 AUG : plug correct cookoon
      @highlighted_cookoon = Cookoon.first.decorate # @quote.cookoons.first.decorate
    end
  end
end
