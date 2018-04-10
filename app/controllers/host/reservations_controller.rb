class Host::ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[edit update]

  def index
    reservations = policy_scope([:host, Reservation]).includes(:cookoon, user: :photo_files)
    @active_reservations = reservations.active.includes(:inventory)
    @inactive_reservations = reservations.inactive
  end

  def edit; end

  def update
    payment = @reservation.payment
    if params['accept']
      payment_captured = @reservation.full_discount? ? true : payment.capture
      if payment_captured
        @reservation.update(reservation_params.merge(status: :accepted))
        @reservation.notify_users_after_confirmation
        flash[:notice] = 'Vous avez accepté la réservation'
      else
        # TODO : Essayer a nouveau de capturer la charge ou afficher une erreur.
        flash[:alert] = payment.displayable_errors
      end
    else
      payment.refund_user_discount
      @reservation.refused!
      ReservationMailer.refused_to_tenant(@reservation).deliver_later
      flash[:notice] = 'Vous avez refusé la réservation'
    end
    redirect_to host_reservations_path
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id])
    authorize [:host, @reservation]
  end

  def reservation_params
    params.require(:reservation).permit(:cleaning, :janitor)
  end
end
