module Pro
  class ReservationsController < ApplicationController
    def index
      @reservations = policy_scope(Reservation)
                      .where('pro_reservations.status >= ?', Reservation.statuses[:accepted])
                      .includes(:cookoon)
                      .decorate
    end

    def show
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation.quote

      respond_to do |format|
        format.html
        format.js
        format.pdf do
          render pdf: "COOKOON · Réservation ##{@reservation.id}"
        end
      end
    end

    def update
      @reservation = Reservation.find(params[:id])
      authorize @reservation.quote

      @reservation.update(reservation_params)
      flash.notice = case @reservation.status
                     when 'modification_requested'
                       'Votre demande de modification a bien été prise en compte'
                     when 'accepted'
                       'Votre réservation est confirmée'
                     end
      redirect_to pro_quotes_path
    end

    private

    def reservation_params
      params.require(:pro_reservation).permit(:status, :requested_modification)
    end
  end
end
