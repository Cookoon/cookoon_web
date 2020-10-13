class ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[update show ask_quotation reset_menu select_services cooking_by_user]
  before_action :find_reservation_with_reservation_id, only: %i[select_cookoon select_menu]
  before_action :find_cookoon, only: %i[select_cookoon]

  def index
    # reservations = policy_scope(Reservation).includes(cookoon: :user)
    reservations = policy_scope(Reservation).includes(:cookoon)
    @active_reservations = ReservationDecorator.decorate_collection(reservations.includes(:menu, :services).active)
    @inactive_reservations = ReservationDecorator.decorate_collection(reservations.includes(:menu, :services).inactive)
  end

  def show
  end

  def new
    @reservation = Reservation.new(category: params[:category]).decorate
    authorize @reservation
  end

  def create
    @reservation = current_user.reservations.build reservation_params
    authorize @reservation

    if @reservation.save
      redirect_to reservation_cookoons_path(@reservation)
    else
      flash.alert = "Votre réservation n'est pas valide, vous devez remplir tous les champs."
      redirect_to root_path
    end
  end

  def update
    @reservation.cancelled!
    # ReservationMailer.cancelled_by_tenant_to_tenant(@reservation).deliver_later
    # ReservationMailer.cancelled_by_tenant_to_host(@reservation).deliver_later
    redirect_to reservations_path
  end

  def select_cookoon
    if @reservation.pending?
      if @reservation.select_cookoon!(@cookoon)
        # redirect_to reservation_chefs_path
        redirect_to reservation_cookoon_path(@reservation, @cookoon)
      else
        redirect_to reservation_cookoons_path(@reservation), alert: "Une erreur s'est produite, veuillez essayer à nouveau"
      end
    else
      redirect_to reservation_cookoon_path(@reservation, @cookoon)
    end
  end

  def ask_quotation
    @reservation.ask_quotation!
    flash.notice = 'Votre demande de devis est enregistrée notre concierge reviendra vers vous rapidement par email !'

    redirect_to reservations_path
  end

  def select_menu
    @reservation.select_menu!(Menu.find(params[:menu_id]))
    @reservation.update(menu_status: "selected")
    # redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
    redirect_to reservation_services_path(@reservation), flash: { check_of_chef_availability_needed: true }
  end

  # def reset_menu
  #   @reservation.select_menu!(nil)
  #   @reservation.update(menu_status: "initial")
  #   redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
  # end

  def cooking_by_user
    @reservation.select_menu!(nil)
    @reservation.update(menu_status: "cooking_by_user")
    # redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
    redirect_to reservation_services_path(@reservation)
  end

  def select_services
    service_categories = params[:reservation][:services].delete_if(&:blank?)
    @reservation.select_services!(service_categories)
    # redirect_to new_reservation_payment_path(@reservation)
    redirect_to new_reservation_payment_path(@reservation)
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id]).decorate
    authorize @reservation
  end

  def find_reservation_with_reservation_id
    @reservation = Reservation.find(params[:reservation_id]).decorate
    authorize @reservation
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id]).decorate
  end

  def reservation_params
    params.require(:reservation).permit(:category, :people_count, :type_name, :start_at)
  end
end
