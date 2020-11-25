module Admin
  class ReservationsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[show]
    before_action :find_reservation_with_reservation_id, only: %i[validate_menu ask_menu_payment validate_services ask_services_payment quotation_is_sent quotation_is_accepted quotation_is_refused]

    def index
      reservations = policy_scope([:admin, Reservation]).includes(:cookoon, :user, menu: [:chef], cookoon: [:user]).order(id: :desc)
      engaged_reservations = reservations.engaged

      @engaged_reservations_to_come = engaged_reservations.starting_after_today
      @engaged_reservations_that_needs_host_action = engaged_reservations.needs_host_action
      @engaged_reservations_that_needs_admin_action = engaged_reservations.needs_admin_action
      @engaged_reservations_that_needs_user_action = engaged_reservations.needs_user_action
      @passed_reservations = engaged_reservations.starting_before_today + reservations.passed
      @reservations_refused_by_host = reservations.refused_by_host
      # @cancelled_reservations_because_host_did_not_reply_in_validity_period = reservations.cancelled_because_host_did_not_reply_in_validity_period
      # @cancelled_reservations_because_short_notice = reservations.cancelled_because_short_notice

      # @engaged_customer_reservations = reservations.customer.engaged_credit_card_payment
      # @engaged_business_with_credit_card_payment_reservations = reservations.business.engaged_credit_card_payment
      # @engaged_business_with_quotation_reservations = reservations.business.engaged_quotation
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

    def quotation_is_sent
      if @reservation.send_quotation!
        flash.notice = "Le statut de la réservation a bien été mis à jour."
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def quotation_is_accepted
      if @reservation.accept_quotation!
        flash.notice = "Le statut de la réservation a bien été mis à jour."
        redirect_to admin_reservation_path(@reservation)
      else
        flash.alert = "Il y a eu un problème"
        render :show
      end
    end

    def quotation_is_refused
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
