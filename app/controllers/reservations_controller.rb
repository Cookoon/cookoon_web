class ReservationsController < ApplicationController
  before_action :find_cookoon, :build_reservation, only: [:create]
  before_action :find_reservation, only: [:edit, :update, :show]

  def index
    @reservations = policy_scope(Reservation.for_tenant)
                    .includes(cookoon: :photo_files)
  end

  def show
  end

  def create
    @reservation.price = @reservation.price_for_rent
    if @reservation.save
      ReservationMailer.new_request(@reservation).deliver_now
      redirect_to new_reservation_paiement_path(@reservation)
    else
      flash[:alert] = 'Erreur'
      redirect_to @cookoon
    end
  end

  def edit
  end

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
