class ReservationsController < ApplicationController
  before_action :find_cookoon, :build_reservation, only: [:create]

  def index
    @reservations = policy_scope(Reservation)
  end

  def create
    @reservation.price = @reservation.price_for_rent
    if @reservation.save
      redirect_to new_reservation_paiement_path(@reservation)
    else
      flash[:alert] = 'Erreur'
      redirect_to @cookoon
    end
  end

  # TODO : #update pour l'annulation

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end

  def build_reservation
    @reservation = current_user.reservations.build(reservation_params)
    authorize @reservation
  end

  def reservation_params
    params.require(:reservation).permit(:duration, :date, :catering).merge(cookoon: @cookoon)
  end
end
