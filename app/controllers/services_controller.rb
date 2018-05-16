class ServicesController < ApplicationController
  before_action :set_reservation, only: %i[show create]
  skip_after_action :verify_authorized, only: :destroy

  def show
    @service = @reservation.services.last
    @credit_cards = current_user.credit_cards
  end

  def create
    @service = @reservation.services.new(full_params)
    if @service.save
      render json: { url: service_path(@service), method: 'delete', selected: 'true' }
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service = Service.find(params[:id])
    authorize @service
    @service.destroy
    render json: { url: reservation_services_path(@service.reservation), method: 'post', selected: 'false' }
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ["Ce service n'existe plus"] }, status: :unprocessable_entity
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation
  end

  def service_params
    params.require(:service).permit(:category)
  end

  def full_params
    if service_params[:category] == 'special'
      service_params
    else
      service_params.merge(payment_tied_to_reservation: true)
    end
  end
end
