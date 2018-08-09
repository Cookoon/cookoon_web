module Pro
  class ReservationsController < ApplicationController
    def show
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation.quote
    end

    def update
      @reservation = Reservation.find(params[:id])
      authorize @reservation.quote

      if @reservation.update(reservation_params)
        flash.notice = 'Votre demande de modification a bien été prise en compte'
        redirect_to pro_quotes_path
      end
    end

    private

    def reservation_params
      params.require(:pro_reservation).permit(:status, :requested_modification)
    end
  end
end
