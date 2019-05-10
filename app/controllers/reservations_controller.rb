class ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[update show]

  def index
    reservations = policy_scope(Reservation).includes(cookoon: :photo_files)
    @active_reservations = reservations.active
    @inactive_reservations = reservations.inactive
  end

  def show
    @cookoon = @reservation.cookoon
  end

  def create
    # TODO Handle erros when user has no search
    @reservation = current_user.reservations.build reservation_params
    authorize @reservation

    if @reservation.save
      redirect_to reservation_cookoons_path(@reservation)
    else
      flash.alert = @reservation.errors.full_messages.join(', ')
      redirect_to root_path
    end
  end

  def update
    @reservation.cancelled!
    ReservationMailer.cancelled_by_tenant_to_tenant(@reservation).deliver_later
    ReservationMailer.cancelled_by_tenant_to_host(@reservation).deliver_later
    redirect_to reservations_path
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id])
    authorize @reservation
  end

  def reservation_params
    params.require(:reservation).permit(:people_count, :duration, :start_at)
  end
end
