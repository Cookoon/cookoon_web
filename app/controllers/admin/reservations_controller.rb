module Admin
  class ReservationsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[show require_payment_for_menu]

    def index
      @reservations = policy_scope([:admin, Reservation]).includes(:cookoon, :user, :menu, cookoon: [:user]).order(id: :desc)
      @reservations_charged = @reservations.charged.decorate
      @reservations_accepted = @reservations.accepted.decorate
    end

    def show
    end

    def require_payment_for_menu
      if @reservation.update(menu_payment_status: "payment_required")
        flash.notice = "Le statut de la réservation a bien été mis à jour"
        # TO DO send email to user to require payment
        render :show
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    private

    def find_reservation
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation, policy_class: Admin::ReservationPolicy
    end

    # def require_admin
    #   current_user.admin == true
    # end

  end
end
