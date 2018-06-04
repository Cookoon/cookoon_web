class Reservations::MessagesController < ApplicationController
  before_action :find_reservation

  def new; end

  def create
    @reservation.update(reservation_params)
    redirect_to home_path
  end

  private

  def find_reservation
    @reservation = Reservation.find params[:reservation_id]
    authorize @reservation
  end

  def reservation_params
    params.require(:reservation).permit(:message_for_host)
  end
end
