class ServicesController < ApplicationController
  before_action :set_reservation

  def show
    @service = @reservation.services.last
    @credit_cards = current_user.credit_cards
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation
  end
end
