class Host::ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[edit update]

  def index
    reservations = policy_scope([:host, Reservation]).includes(:cookoon, user: :photo_files)
    @active_reservations = reservations.active.includes(:inventory)
    @inactive_reservations = reservations.inactive
  end

  def edit; end

  def update
    status = params['accept'] ? :accepted : :refused
    merged_params = reservation_params.merge(status: status)

    if @reservation.update(merged_params)
      if @reservation.accepted?
        payment = Reservation::Payment.new(@reservation)
        if payment.capture
          @reservation.notify_users_after_confirmation
          flash[:notice] = 'Vous avez accepté la réservation'
        else
          # TODO : Essayer a nouveau de capturer la charge ou afficher une erreur.
          # Attention au status de la reservation qui peut etre erronne si la charge n'est pas correctement capturee
          flash[:alert] = payment_service.displayable_errors
        end
      else
        @reservation.refund_discount_to_user if @reservation.payment.discount_used?
        ReservationMailer.refused_to_tenant(@reservation).deliver_later
        flash[:notice] = 'Vous avez refusé la réservation'
      end

      redirect_to host_reservations_path
    else
      flash[:alert] = 'Erreur'
      render :edit
    end
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
