class ReservationsController < ApplicationController
  before_action :find_cookoon, only: :create
  before_action :find_reservation, only: %i[edit update show]

  def index
    reservations = policy_scope(Reservation).includes(cookoon: :photo_files)
    @active_reservations = reservations.active
    @inactive_reservations = reservations.inactive
  end

  def show; end

  def create
    @reservation = current_user.reservations.new(reservation_params)
    authorize @reservation

    if @reservation.save
      redirect_to new_reservation_payment_path(@reservation)
    else
      render 'reservations/new'
    end
  end

  def edit; end

  def update
    @reservation.cancelled!
    ReservationMailer.cancelled_request(@reservation).deliver_later
    ReservationMailer.cancelled_by_tenant(@reservation).deliver_later
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

  def reservation_params
    params.require(:reservation)
          .permit(:start_at, :duration, :catering)
          .delocalize(start_at: :time)
          .merge(cookoon: @cookoon)
  end
end
