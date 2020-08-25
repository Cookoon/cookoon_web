module Admin
  class ReservationsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[show]
    before_action :find_reservation_with_reservation_id, only: %i[validate_menu ask_menu_payment validate_services ask_services_payment]

    def index
      @reservations = policy_scope([:admin, Reservation]).includes(:cookoon, :user, menu: [:chef], cookoon: [:user]).order(id: :desc)
    end

    def show
    end

    def validate_menu
      if @reservation.update(menu_status: "validated")
        flash.notice = "Le menu a bien été validé"
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def ask_menu_payment
      if @reservation.update(menu_status: "payment_required")
        flash.notice = "Le paiement du menu va bien être demandé"
        # TO DO send email to user to require payment
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def validate_services
      if @reservation.update(services_status: "validated")
        flash.notice = "Les services ont bien été validés"
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def ask_services_payment
      if @reservation.update(services_status: "payment_required")
        flash.notice = "Le paiement des services va bien être demandé"
        # TO DO send email to user to require payment
        redirect_to admin_reservation_path(@reservation)
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

    def find_reservation_with_reservation_id
      @reservation = Reservation.find(params[:reservation_id]).decorate
      authorize @reservation, policy_class: Admin::ReservationPolicy
    end

    # def require_admin
    #   current_user.admin == true
    # end

  end
end
