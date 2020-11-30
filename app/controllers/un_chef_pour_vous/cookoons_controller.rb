class UnChefPourVous::CookoonsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show select_cookoon]
  before_action :find_reservation, only: %i[index show select_cookoon]

  def index
    cookoons = Cookoon.amex.accomodates_for(@reservation).includes(:main_photo_files)
    @cookoons_available = cookoons.available_in_day(@reservation.start_at).decorate
    @cookoons_unavailable = cookoons.unavailable_in_day(@reservation.start_at).decorate
  end

  def show
    raise
  end

  def select_cookoon
    raise
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

end
