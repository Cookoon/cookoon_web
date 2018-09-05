module Pro
  class ReservationsController < ApplicationController
    def index
      @reservations = policy_scope(Reservation)
                      .where('pro_reservations.status >= ?', Reservation.statuses[:accepted])
                      .includes(:cookoon)
                      .order(created_at: :desc)
                      .decorate
    end

    def show
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation.quote
    end

    def update
      @reservation = Reservation.find(params[:id])
      authorize @reservation.quote

      @reservation.update(reservation_params)
      case @reservation.status
      when 'modification_requested'
        flash.notice = 'Votre demande de modification a bien été prise en compte'
      when 'accepted'
        ReservationMailer.accepted(@reservation).deliver_later
        flash.notice = 'Votre réservation est confirmée'
      end
      redirect_to pro_quotes_path
    end

    private

    def reservation_params
      params.require(:pro_reservation).permit(:status, :requested_modification)
    end
  end
end
