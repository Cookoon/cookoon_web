class Reservations::GuestsController < ApplicationController
  before_action :set_reservation, only: [:index, :create, :create_all]
  before_action :disable_turbolinks_preview_cache, only: :index

  def index
    @guests = policy_scope([:reservation, @reservation.guests])
    @user_guests = current_user.guests.where.not(id: @reservation.guest_ids)
    @guest = Guest.new
  end

  def create
    @guest = current_user.guests.new(guest_params)
    authorize [:reservation, @guest]

    if @guest.save
      redirect_to reservation_guests_path(@reservation),
                  action: 'replace',
                  notice: 'Votre nouveau contact est prêt à être convié !'
    else
      render :new
    end
  end

  def create_all
    if params.dig(:reservation, :guest_ids).any?(&:present?) && @reservation.update(reservation_params)
      ReservationMailer.invitations_sent(@reservation).deliver_later
      redirect_to edit_reservation_path(@reservation), notice: 'Vos invités ont bien été conviés'
    else
      flash.alert = "Vous n'avez sélectionné aucun contact"
      redirect_to reservation_guests_path(@reservation)
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize @reservation, :update?
  end

  def guest_params
    params.require(:guest).permit(:email, :first_name, :last_name)
  end

  def reservation_params
    params
      .require(:reservation)
      .permit(guest_ids: [])
      .to_h
      .merge(guest_ids: @reservation.guest_ids) do |_key, old_val, new_val|
        old_val | new_val
      end
  end
end
