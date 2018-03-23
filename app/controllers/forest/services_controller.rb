module Forest
  class ServicesController < ForestLiana::ApplicationController
    before_action :set_reservation, only: :create

    def create
      if params.dig(:data, :attributes, :ids).size != 1
        render_error 'More than 1 Reservation was selected, Service can only be created on a single Reservation'
      elsif @reservation.services.create(service_params)
        render json: { html: "<h1>Service created!</h1><p>URL:</p><br/><p>#{reservation_services_url(@reservation)}</p>" }
      else
        render_error 'Your service could not be created'
      end
    end

    private

    def set_reservation
      @reservation = ::Reservation.find(params.dig(:data, :attributes, :ids)&.first)
    end

    def service_params
      params.require(:data).require(:attributes).require(:values)
            .permit(:content, :price)
    end

    def render_error(message)
      render json: { html: "<h1>Error</h1><p>#{message}</p>" }
    end
  end
end
