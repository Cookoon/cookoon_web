class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_reservation, only: %i[index show select_cookoon select_menu]
  before_action :find_cookoon, only: %i[edit update select_cookoon]

  def index
    filtering_params = {
      accomodates_for: @reservation.people_count,
      available_in: (@reservation.start_at..@reservation.end_at),
      available_for: current_user
    }

    @cookoons = policy_scope(Cookoon)
                .includes(:photo_files)
                .filtrate(filtering_params)
                .decorate
  end

  def show
    @service_categories = build_service_categories
    @cookoon = Cookoon.includes(perks: :perk_specification).find(params[:id]).decorate
    authorize @cookoon
    @reservation.select_cookoon(@cookoon)
    @reservation.assign_prices
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

  def select_cookoon
    @reservation.select_cookoon(@cookoon)
    @reservation.select_services!
    redirect_to new_reservation_payment_path(@reservation)
  end

  def select_menu
    @menu = Menu.find(params[:id])
    authorize @menu
    @reservation.select_menu!(@menu)
    redirect_to reservation_cookoons_path(@reservation)
  end

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:id])
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

  def build_service_categories
    reservation_service_categories = @reservation.services.pluck(:category)
    Service.categories.keys.reverse.map do |category|
      if reservation_service_categories.exclude? category
        { url: reservation_services_path(@reservation), method: 'post', selected: 'false' }
      else
        reservation_service = @reservation.services.find_by(category: category)
        { url: service_path(reservation_service), method: 'delete', selected: 'true' }
      end.merge(display_options_for(category))
    end
  end

  def display_options_for(category)
    case category
    when 'corporate'
      { icon_name: 'pro', display_name: "Carnets,<br />eau, etc." }
    when 'chef'
      { icon_name: 'chef', display_name: 'Chef<br />privé' }
    when 'catering'
      { icon_name: 'food', display_name: 'Plateaux<br />repas' }
    when 'special'
      { icon_name: 'concierge', display_name: 'Un besoin<br />particulier ?' }
    end.merge(category: category)
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      { lat: cookoon.latitude, lng: cookoon.longitude }
    end
  end
end
