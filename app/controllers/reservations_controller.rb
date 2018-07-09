class ReservationsController < ApplicationController
  before_action :find_cookoon, only: :create
  before_action :find_reservation, only: %i[edit update show]

  def index
    reservations = policy_scope(Reservation).includes(cookoon: :photo_files)
    @active_reservations = reservations.active
    @inactive_reservations = reservations.inactive
  end

  def show; end

  def create
    # TODO Handle erros when user has no search
    search = current_user.cookoon_searches.last
    # TODO: FC replace old way?
    # search = current_user.current_search
    params_from_search = search.to_reservation_attributes.merge(cookoon: @cookoon)
    @reservation = Reservation.new params_from_search
    authorize @reservation

    if @reservation.save
      redirect_to new_reservation_payment_path(@reservation)
    else
      flash.alert = @reservation.errors.full_messages.join(', ')
      redirect_to @cookoon
    end
  end

  def edit
    @cookoon = @reservation.cookoon
  end

  def update
    @reservation.cancelled!
    ReservationMailer.cancelled_by_tenant_to_tenant(@reservation).deliver_later
    ReservationMailer.cancelled_by_tenant_to_host(@reservation).deliver_later
    redirect_to reservations_path
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:id])
    authorize @reservation
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end
end
