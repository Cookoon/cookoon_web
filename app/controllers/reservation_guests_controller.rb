class ReservationGuestsController < ApplicationController
  before_action :set_reservation

  def index
    @reservation_guests = policy_scope(@reservation.reservation_guests).includes(:guest)
    @guests = current_user.guests - @reservation.guests # TODO: FC 15feb18 refactor with Arel query
  end

  def create
    reservation_guests_was = @reservation.guests.to_a

    if @reservation.update(reservation_params)
      redirect_to edit_reservation_path(@reservation), notice: 'Vos invités ont bien été conviés'

      new_reservation_guests = @reservation.guests - reservation_guests_was
      ReservationMailer.invitations_sent(@reservation, new_reservation_guests).deliver_later
    else
      flash.now.alert = @reservation.errors.full_messages.join(' · ')
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation, :update?
  end

  def reservation_params
    permitted_params = params
                       .require(:reservation)
                       .permit(
                         guest_ids: [],
                         guests_attributes: %i[user_id first_name last_name email]
                       )
                       .to_h
                       .merge(guest_ids: @reservation.guest_ids) do |_key, old_val, new_val|
                         old_val | new_val
                       end
    return permitted_params unless permitted_params[:guests_attributes]
    enrich_guest_attributes(permitted_params)
  end

  def enrich_guest_attributes(permitted_params)
    guests_attributes = permitted_params[:guests_attributes]
                        .transform_values do |v|
                          v.merge(user_id: current_user.id)
                        end
    permitted_params.merge(guests_attributes: guests_attributes)
  end
end
