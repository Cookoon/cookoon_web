class ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[update show ask_quotation reset_menu select_services cooking_by_user reset_cooking_by_user]

  def index
    reservations = policy_scope(Reservation).includes(cookoon: :user)
    @active_reservations = ReservationDecorator.decorate_collection(reservations.active)
    @inactive_reservations = ReservationDecorator.decorate_collection(reservations.inactive)
  end

  def show
    @cookoon = @reservation.cookoon
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
      flash.alert = "Oops, votre réservation n'est pas valide, vous devez remplir tous les champs"
      redirect_to root_path
    end
  end

  def update
    @reservation.cancelled!
    ReservationMailer.cancelled_by_tenant_to_tenant(@reservation).deliver_later
    ReservationMailer.cancelled_by_tenant_to_host(@reservation).deliver_later
    redirect_to reservations_path
  end

  def ask_quotation
    @reservation.ask_quotation!
    flash.notice = 'Votre demande de devis est enregistrée notre concierge reviendra vers vous rapidement par email !'

    redirect_to reservations_path
  end

  def select_menu
    @reservation = Reservation.find(params[:reservation_id]).decorate
    authorize @reservation
    @reservation.select_menu!(Menu.find(params[:id]))
    @reservation.update(menu_status: "selected")
    redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
  end

  def reset_menu
    @reservation.select_menu!(nil)
    @reservation.update(menu_status: "initial")
    redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
  end

  def cooking_by_user
    @reservation.update(menu_status: "cooking_by_user")
    redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
  end

  def reset_cooking_by_user
    @reservation.update(menu_status: "initial")
    redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon, anchor: 'reservation-menus-title')
  end

  def select_services
    if @reservation.menu_status == "initial"
      flash.alert = "Vous devez choisir un menu ou indiquer si vous souhaitez cuisiner vous-même"
      redirect_to reservation_cookoon_path(@reservation, @reservation.cookoon)
    else
      service_categories = params[:reservation][:services].delete_if(&:blank?)
      @reservation.select_services!(service_categories)
      redirect_to new_reservation_payment_path(@reservation)
    end
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id]).decorate
    authorize @reservation
  end

  def reservation_params
    params.require(:reservation).permit(:category, :people_count, :type_name, :start_at)
  end
end
