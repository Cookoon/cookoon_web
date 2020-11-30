class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_reservation, only: %i[index show]
  before_action :find_cookoon, only: %i[show]

  def index
    filtering_params = {
      # accomodates_for: (@reservation.people_count),
      accomodates_for: (@reservation),
      # available_in: (@reservation.start_at..@reservation.end_at),
      # available_in: (@reservation.start_at_for_chef_and_service..@reservation.end_at_for_chef_and_service),
      available_in_day: (@reservation.start_at),
      available_for: current_user
    }

    @cookoons = policy_scope(Cookoon)
                .includes(:main_photo_files)
                .filtrate(filtering_params)
                .order(price_cents: :desc)
                .decorate
  end

  # def show
  #   @reservation.select_cookoon!(@cookoon)
  #   @chefs = policy_scope(Chef).includes(:menus).decorate
  # end

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

  def find_cookoon
    @cookoon = Cookoon.find(params[:id]).decorate
    authorize @cookoon
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
    authorize(@reservation, :update?)
  end
end
