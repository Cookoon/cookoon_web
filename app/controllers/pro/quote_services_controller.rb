module Pro
  class QuoteServicesController < ApplicationController
    def index
      @quote = Quote.find(params[:quote_id]).decorate

      @highlighted_cookoon = @quote.cookoons.first.decorate

      @quote_service_categories = build_quote_service_categories
    end

    def create
      @quote = Quote.find(params[:quote_id])
      @quote_service = @quote.services.new(quote_service_params.merge(quantity: @quote.people_count))
      authorize @quote_service

      if @quote_service.save
        render json: {
          url: pro_service_path(@quote_service),
          method: 'delete',
          selected: 'true',
          quantity: @quote_service.quantity,
          html_data: render_to_string(partial: 'pro/quotes/price_estimation', locals: {quote: @quote.decorate})
        }
      else
        render json: { errors: @quote_service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @quote_service = QuoteService.find(params[:id])
      authorize @quote_service

      @quote = @quote_service.quote

      if @quote_service.update(quote_service_params)
        render json: {
          quantity: @quote_service.quantity,
          html_data: render_to_string(partial: 'pro/quotes/price_estimation', locals: {quote: @quote.decorate})
        }
      else
        render json: { errors: @quote_service.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @quote_service = Pro::QuoteService.find(params[:id])
      authorize @quote_service

      @quote = @quote_service.quote

      @quote_service.destroy
      render json: {
        url: pro_quote_services_path(@quote_service.quote),
        method: 'post',
        selected: 'false',
        html_data: render_to_string(partial: 'pro/quotes/price_estimation', locals: {quote: @quote.decorate})
      }
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ["Ce service n'existe plus"] }, status: :unprocessable_entity
    end

    private

    def quote_service_params
      params.require(:service).permit(:category, :quantity)
    end

    # TODO: CP 2may2018 Try to refactor this
    def build_quote_service_categories
      quote_service_categories = policy_scope(@quote.services).pluck(:category)

      ::Service.categories.keys.reverse.map do |category|
        if quote_service_categories.exclude? category
          { url: pro_quote_services_path(@quote), method: 'post', selected: 'false' }
        else
          quote_service = @quote.services.find_by(category: category)
          { url: pro_service_path(quote_service), method: 'delete', selected: 'true', quantity: quote_service.quantity }
        end.merge(display_options_for(category))
      end
    end

    # TODO: FC 02aug18 fix duplication from services_controller
    def display_options_for(category)
      case category
      when 'corporate'
        { icon_name: 'pro', display_name: 'Carnets,<br />eau, etc.' }
      when 'chef'
        { icon_name: 'chef', display_name: 'Chef<br />privé' }
      when 'catering'
        { icon_name: 'food', display_name: 'Plateaux<br />repas' }
      when 'special'
        { icon_name: 'concierge', display_name: 'Un besoin<br />particulier ?' }
      end.merge(category: category)
    end
  end
end
