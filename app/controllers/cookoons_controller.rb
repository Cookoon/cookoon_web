class CookoonsController < ApplicationController
  include DatetimeHelper

  def index
    @lat_lng = cookies[:lat_lng].try(:split, "|")
    @new_search = UserSearch.new(number: 2, duration: 2, date: Time.zone.now + 3.days)
    @last_search = current_search || @new_search
    @cookoons = policy_scope(Cookoon).near(@last_search.address.presence || 'Paris' || @lat_lng, 10) # revert back Paris and @lat_lng to use user position
    prepare_infos
    build_markers
  end

  def new
    @cookoon = Cookoon.new
    authorize @cookoon
  end

  def create
    @cookoon = current_user.cookoons.build(cookoon_params)
    authorize @cookoon
    if @cookoon.save
      if current_user.stripe_account_id
        redirect_to @cookoon
      else
        flash[:notice] = "Vous avez presque terminé ! Pour que votre Cookoon soit visible et recevoir des paiements, \
        vous devez connecter votre compte à notre organisme de paiement partenaire."
        redirect_to new_stripe_account_path
      end
    else
      render :new
    end
  end

  def show
    @cookoon = Cookoon.find(params[:id])
    authorize @cookoon
    @reservation = current_user.reservations.build(
      cookoon: @cookoon,
      date: current_search.try(:date) || Time.zone.now + 3.days,
      duration: current_search.try(:duration) || 2
    )
  end

  private

  def cookoon_params
    params.require(:cookoon).permit(:name, :surface, :price, :address, :capacity, :category, photos: [])
  end

  def prepare_infos
    @search_infos = {
      position: @last_search.address.try(:split, " - ").try(:first) || 'Adresse',
      time_slot: display_datetime_for(@last_search.date, join_expression: 'à', without_year: true, time_separator: ':') || 'Tout de suite',
      people_number: @last_search.number || 4
    }
  end

  def build_markers
    @hash = Gmaps4rails.build_markers(@cookoons) do |cookoon, marker|
      marker.lat cookoon.latitude
      marker.lng cookoon.longitude
    end
  end
end
