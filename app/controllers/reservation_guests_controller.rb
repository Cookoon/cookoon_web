class ReservationGuestsController < ApplicationController
  before_action :set_reservation

  def index
    @reservation_guests = policy_scope(@reservation.reservation_guests).includes(:guest)
    @reservation_guest = ReservationGuest.new(guest: Guest.new)
    @guests = current_user.guests - @reservation.guests
  end

  def create
    @reservation_guest = @reservation.reservation_guests.new(reservation_guest_params)
    authorize @reservation_guest

    if @reservation_guest.save
      redirect_to reservation_reservation_guests_path(@reservation),
                  action: 'replace',
                  notice: 'Votre invité a bien été convié'
    else
      flash.now.alert = @reservation_guest.errors.full_messages.join(' · ')
      render :index
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation, :update?
  end

  def reservation_guest_params
    permitted_params = params.require(:reservation_guest).permit(
      :guest_id,
      guest_attributes: %i[id first_name last_name email _destroy]
    )

    return permitted_params unless permitted_params[:guest_attributes]

    permitted_params.to_h.deep_merge(guest_attributes: { user_id: current_user.id })
  end
end
