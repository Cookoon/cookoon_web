class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_cookoon, only: %i[edit update]
  before_action :find_search, only: %i[index show]

  def index
    skip_policy_scope && (return redirect_to root_path) unless @search

    filtering_params = {
      accomodates_for: @search.people_count,
      available_in: (@search.start_at..@search.end_at)
    }
    @cookoons = policy_scope(Cookoon)
                .includes(:photo_files)
                .filtrate(filtering_params)
                .decorate

    # TODO : Will we keep markers when done ?
    build_markers
  end

  def show
    @cookoon = Cookoon.includes(perks: :perk_specification).find(params[:id]).decorate
    authorize @cookoon

    params_from_search = @search.to_reservation_attributes.merge(cookoon: @cookoon)
    @reservation = Reservation.new params_from_search

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
      # other error messages are already displayed on form
      flash.now.alert = @cookoon.errors.messages[:user].join
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
    @search = current_user.cookoon_searches.last
    # TODO: FC replace old way?
    # @search = current_user&.current_search || new_default_search
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
    CookoonSearch.new CookoonSearch.default_params
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      { lat: cookoon.latitude, lng: cookoon.longitude }
    end
  end
end
