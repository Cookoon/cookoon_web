module Host
  class ReservationsController < ApplicationController
    before_action :find_reservation, only: %i[update]

    def index
      reservations = policy_scope([:host, Reservation]).includes(:cookoon, :user)
      @active_reservations = ReservationDecorator.decorate_collection(reservations.active)
      @inactive_reservations = ReservationDecorator.decorate_collection(reservations.inactive)
    end

    def update
      # params['accept'].present? ? capture_payment_and_notify : refund_payment_and_notify
      params['accept'].present? ? capture_payment_and_notify : cancel_payment_and_notify
      redirect_to host_reservations_path
    end

    private

    def find_reservation
      @reservation = Reservation.find(params[:id])
      authorize [:host, @reservation]
    end

    def capture_payment_and_notify
      payment = @reservation.payment
      # if payment.capture
      if payment.capture(:stripe_charge_id)
        @reservation.accept!
        @reservation.update(cookoon_butler_payment_status: "captured")
        @reservation.notify_users_after_host_confirmation
        flash[:notice] = 'Vous avez accepté la réservation'
      else
        # TODO : Essayer a nouveau de capturer la charge ou afficher une erreur.
        flash[:alert] = payment.displayable_errors
      end
    end

    # def refund_payment_and_notify
    def cancel_payment_and_notify
      # @reservation.payment.refund
      # @reservation.payment.cancel
      @reservation.payment.cancel(:stripe_charge_id)
      @reservation.refuse!
      @reservation.update(cookoon_butler_payment_status: "cancelled")
      # ReservationMailer.refused_to_tenant(@reservation).deliver_later
      flash[:notice] = 'Vous avez refusé la réservation'
    end
  end
end
