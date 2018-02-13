class ReservationGuestsController < ApplicationController
  before_action :set_reservation

  def index
    set_reservation_guests
    @reservation_guest = ReservationGuest.new
    set_guests
  end

  def create
    @reservation_guest = @reservation.reservation_guests.new(reservation_guest_params)
    authorize @reservation_guest

    if @reservation_guest.save
      redirect_to reservation_reservation_guests_path(@reservation),
                  notice: 'Votre invité a bien été convié'
    else
      set_reservation_guests
      set_guests
      render :index
    end
  end

  private

  def set_reservation_guests
    @reservation_guests = policy_scope(@reservation.reservation_guests).includes(:guest)
  end

  def set_guests
    @guests = current_user.guests - @reservation.guests
  end

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation, :update?
  end

  def reservation_guest_params
    permitted_params = params.require(:reservation_guest).permit(
      :guest_id,
      guest_attributes: %i[id user_id first_name last_name email _destroy]
    )

    return permitted_params unless permitted_params.dig(:reservation_guest, :guest_attributes)

    permitted_params.to_h.deep_merge(guest_attributes: { user_id: current_user.id })
  end
end
