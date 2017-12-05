class ReservationsController < ApplicationController
  before_action :find_cookoon, :build_reservation, only: [:create]
  before_action :find_reservation, only: %i[edit update show]

  def index
    @reservations = policy_scope(Reservation)
  end

  def show; end

  def create
    @reservation.price = @reservation.price_for_rent
    trello_service = TrelloReservationService.new(reservation: @reservation)
    if trello_service.create_trello_card_and_save_reservation
      ReservationMailer.new_request(@reservation).deliver_now
      redirect_to new_reservation_paiement_path(@reservation)
    else
      flash[:alert] = 'Une erreur est survenue, veuillez réessayer'
      redirect_to @cookoon
    end
  end

  def edit; end

  def update
    @reservation.cancelled!
    redirect_to reservations_path
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id])
    authorize @reservation
  end

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
