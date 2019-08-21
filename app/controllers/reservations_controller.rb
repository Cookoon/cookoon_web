class ReservationsController < ApplicationController
  before_action :find_reservation, only: %i[update show ask_quotation]

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
      redirect_path = @reservation.needs_chef? ? reservation_chefs_path(@reservation) : reservation_cookoons_path(@reservation)
      redirect_to redirect_path
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
    # probably redirect to my::reservations#index or equivalent
    redirect_to root_path
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
