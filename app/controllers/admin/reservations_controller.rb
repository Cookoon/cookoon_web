module Admin
  class ReservationsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[show]

    def index
      @reservations = policy_scope([:admin, Reservation]).includes(:cookoon, :user, :menu, cookoon: [:user])
      @reservations_charged = @reservations.charged.decorate
      @reservations_accepted = @reservations.accepted.decorate
    end

    def show
    end

    private

    def find_reservation
      @reservation = Reservation.find(params[:id]).decorate
      authorize @reservation
    end

    # def require_admin
    #   current_user.admin == true
    # end

  end
end
