module Pro
  class ServicesController < ApplicationController
    # TODO FC 02 AUG : Use actual pundit policies
    skip_after_action :verify_policy_scoped
    skip_after_action :verify_authorized

    def index
      @quote = Quote.find(params[:quote_id]).decorate

      # TODO FC 02 AUG : plug correct cookoon
      @highlighted_cookoon = Cookoon.first.decorate # @quote.cookoons.first.decorate

      @service_categories = build_service_categories
    end

    def create
      @quote = Quote.find(params[:quote_id])

      @service = @quote.services.new(service_params)
      if @service.save
        render json: { url: pro_service_path(@service), method: 'delete', selected: 'true' }
      else
        render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @service = Pro::QuoteService.find(params[:id])

      @service.destroy
      render json: { url: pro_quote_services_path(@service.quote), method: 'post', selected: 'false' }
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ["Ce service n'existe plus"] }, status: :unprocessable_entity
    end

    private

    def service_params
      params.require(:service).permit(:category)
    end

    # TODO: CP 2may2018 Try to refactor this
    def build_service_categories
      quote_service_categories = @quote.services.pluck(:category)
      Service.categories.keys.reverse.map do |category|
        if quote_service_categories.exclude? category
          { url: pro_quote_services_path(@quote), method: 'post', selected: 'false' }
        else
          quote_service = @quote.services.find_by(category: category)
          { url: pro_service_path(quote_service), method: 'delete', selected: 'true' }
        end.merge(display_options_for(category))
      end
    end

    def display_options_for(category)
      case category
      when 'corporate'
        { icon_name: 'pro', display_name: 'Carnets,<br />eau, etc.' }
      when 'chef'
        { icon_name: 'chef', display_name: 'Chef à<br />domicile' }
      when 'catering'
        { icon_name: 'food', display_name: 'Plateaux<br />repas' }
      when 'special'
        { icon_name: 'concierge', display_name: 'Un besoin<br />particulier ?' }
      end.merge(category: category)
    end
  end
end
