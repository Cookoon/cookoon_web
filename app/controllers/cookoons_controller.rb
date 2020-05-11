class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_reservation, only: %i[index show]
  before_action :find_cookoon, only: %i[show edit update]

  def index
    filtering_params = {
      accomodates_for: @reservation.people_count,
      available_in: (@reservation.start_at..@reservation.end_at),
      available_for: current_user
    }

    @cookoons = policy_scope(Cookoon)
                .includes(:photo_files, :perk_specifications, :perks)
                .filtrate(filtering_params)
                .decorate
  end

  def show
    @reservation.select_cookoon!(@cookoon)
    @chefs = policy_scope(Chef).includes(:menus).decorate
    @perks = @cookoon.perks.includes(:perk_specification)
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
    @cookoon = Cookoon.find(params[:id]).decorate
    authorize @cookoon
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def cookoon_params
    params.require(:cookoon).permit(
      :name, :surface, :price, :address, :capacity, :category,
      :digicode, :building_number, :floor_number, :door_number,
      :wifi_network, :wifi_code, :caretaker_instructions,
      photos: []
    )
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      { lat: cookoon.latitude, lng: cookoon.longitude }
    end
  end
end
