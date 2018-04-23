class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_cookoon, only: %i[edit update]
  before_action :find_search, only: %i[index show]

  def index
    @new_search = @search.dup

    filtering_params = {
      accomodates_for: @search.people_count,
      near_default_radius: @search.address,
      available_in: (@search.start_at..@search.end_at)
    }
    @cookoons = policy_scope(Cookoon).includes(:photo_files).filter(filtering_params).randomize
    build_markers
  end

  def show
    @cookoon = Cookoon.find(params[:id])
    authorize @cookoon

    @reservation = current_user.reservations.new(
      @search.slice(:start_at, :duration).merge(cookoon: @cookoon)
    )
    @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
  end

  def new
    @cookoon = Cookoon.new
    authorize @cookoon
  end

  def create
    @cookoon = current_user.cookoons.new(cookoon_params)
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

  def edit; end

  def update
    if @cookoon.update(cookoon_params)
      redirect_to host_dashboard_path, notice: 'Votre Cookoon a été édité !'
    else
      render :new
    end
  end

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:id])
    authorize @cookoon
  end

  def find_search
    @search = current_user&.current_search || new_default_search
  end

  def cookoon_params
    params.require(:cookoon).permit(
      :name, :surface, :price, :address, :capacity, :category,
      :digicode, :building_number, :floor_number, :door_number,
      :wifi_network, :wifi_code, :caretaker_instructions,
      photos: []
    )
  end

  def new_default_search
    Search.new Search.default_params
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      { lat: cookoon.latitude, lng: cookoon.longitude }
    end
  end
end
