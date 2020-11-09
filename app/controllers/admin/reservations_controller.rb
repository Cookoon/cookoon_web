module Admin
  class ReservationsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[show]
    before_action :find_reservation_with_reservation_id, only: %i[validate_cookoon_butler validate_menu ask_menu_payment validate_services ask_services_payment quotation_sent quotation_accepted quotation_refused]

    def index
      @reservations = policy_scope([:admin, Reservation]).includes(:cookoon, :user, menu: [:chef], cookoon: [:user]).order(id: :desc)
    end

    def show
    end

    def validate_cookoon_butler
      if @reservation.update(cookoon_butler_payment_status: "validated")
        flash.notice = "Le décor a bien été validé"
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
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
        @reservation.notify_users_menu_payment_required
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def validate_services
      if @reservation.update(services_status: "validated")
        @reservation.assign_prices
        if @reservation.save
          redirect_to admin_reservation_path(@reservation), notice: "Les services ont bien été validés."
        else
          flash.alert = "Il y a eu un problème"
          render :show
        end
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def ask_services_payment
      if @reservation.update(services_status: "payment_required")
        flash.notice = "Le paiement des services va bien être demandé"
        @reservation.notify_users_services_payment_required
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def quotation_sent
      if @reservation.send_quotation!
        flash.notice = "Le statut de la réservation a bien été mis à jour."
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def quotation_accepted
      if @reservation.accept_quotation!
        flash.notice = "Le statut de la réservation a bien été mis à jour."
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def quotation_refused
      if @reservation.refuse_quotation!
        flash.notice = "Le statut de la réservation a bien été mis à jour."
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
