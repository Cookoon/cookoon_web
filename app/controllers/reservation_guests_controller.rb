class ReservationGuestsController < ApplicationController
  before_action :set_reservation

  def index
    @reservation_guests = policy_scope(@reservation.reservation_guests).includes(:guest)
  end

  def create
    if @reservation.update(reservation_params)
      redirect_to reservation_reservation_guests_path(@reservation),
                  action: 'replace',
                  notice: 'Vos invités ont bien été conviés'
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
                       .delocalize(date: :time)
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
