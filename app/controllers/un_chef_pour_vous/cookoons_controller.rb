class UnChefPourVous::CookoonsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_reservation, only: %i[index show]
  before_action :find_cookoon, only: %i[show]

  def index
    cookoons = Cookoon.amex.accomodates_for(@reservation).includes(:main_photo_files)
    @cookoons_available = cookoons.available_in_day(@reservation.start_at).decorate
    @cookoons_unavailable = cookoons.unavailable_in_day(@reservation.start_at).decorate
  end

  def show
    @sample_photos = @cookoon.sample_photos
    if @cookoon.geocoded?
      @marker = {
        lat: @cookoon.latitude,
        lng: @cookoon.longitude
      }
    end
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:id]).decorate
  end

end
