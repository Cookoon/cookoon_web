module Pro
  class ReservationsController < ApplicationController
    def show
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation.quote
    end
  end
end
