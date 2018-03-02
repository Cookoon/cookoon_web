class CookoonsController < ApplicationController
  include DatetimeHelper
  before_action :find_cookoon, only: %i[edit update]

  def index
    @new_search = build_search
    @user_search = current_search || @new_search
    @cookoons = filter_cookoons(@user_search)

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
      start_at: current_search.try(:date) || Time.zone.now + 3.days,
      duration: current_search.try(:duration) || 2
    )
    @marker = { lat: @cookoon.latitude, lng: @cookoon.longitude }
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

  def cookoon_params
    params.require(:cookoon).permit(:name, :surface, :price, :address, :capacity, :category, photos: [])
  end

  def build_search
    UserSearch.new(number: 2, duration: 2, date: (Time.zone.now + 3.days).beginning_of_hour)
  end

  def filter_cookoons(user_search)
    # Here we can use @lat_lng to get user position
    # @lat_lng = cookies[:lat_lng].try(:split, "|")
    # requires to turn on scripts on pages
    base_scope = policy_scope(Cookoon).capacity_greater_than(user_search.number)
    if user_search.address.present?
      base_scope.near(user_search.address, 10)
    else
      base_scope.shuffled
    end
  end

  def prepare_infos
    @search_infos = {
      position: @user_search.address.try(:split, " - ").try(:first) || 'Adresse',
      time_slot: display_datetime_for(@user_search.date, join_expression: 'à', without_year: true, time_separator: ':') || 'Tout de suite',
      people_number: @user_search.number || 4
    }
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      {
        lat: cookoon.latitude,
        lng: cookoon.longitude
      }
    end
  end
end
