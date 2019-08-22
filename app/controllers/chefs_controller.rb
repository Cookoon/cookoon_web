class ChefsController < ApplicationController
  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end
end