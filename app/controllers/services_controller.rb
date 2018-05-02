class ServicesController < ApplicationController
  before_action :set_reservation, only: %i[show create]

  def show
    @service = @reservation.services.last
    @credit_cards = current_user.credit_cards
  end

  def create
    full_params = service_params.merge(status: :tied_to_reservation)
    @service = @reservation.services.new(full_params)
    @service.save
    render json: { url: service_path(@service), method: 'delete', selected: 'true' }
  end

  def destroy
    @service = Service.find(params[:id])
    authorize @service
    @service.destroy
    render json: { url: reservation_services_path(@service.reservation), method: 'post', selected: 'false' }
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation
  end

  def service_params
    params.require(:service).permit(:category)
  end
end
