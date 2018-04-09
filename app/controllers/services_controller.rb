class ServicesController < ApplicationController
  before_action :set_reservation

  def show
    payment_service = StripePaymentService.new(
      user: current_user,
      reservation: @reservation
    )
    @service = @reservation.services.last
    @credit_cards = payment_service.user_sources.try(:data)
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation
  end
end
