class CookoonsController < ApplicationController
  include DatetimeHelper

  before_action :find_cookoon, only: %i[edit update]
  before_action :find_user_search, only: %i[index show]

  def index
    @cookoons = filter_cookoons(@user_search)
    # filtering_params = {
    #   near_default_radius: @user_search.address,
    #   available_in: @user_search.start_at..@user_search.end_at,
    #   accomodates_for: @user_seach.people_count
    # }
    # @cookoons = Cookoon.filter(filtering_params)
    build_markers
  end

  def show
    @cookoon = Cookoon.find(params[:id])
    authorize @cookoon

    @reservation = current_user.reservations.new(
      @user_search.slice(:start_at, :duration).merge(cookoon: @cookoon)
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

  def find_user_search
    @user_search = current_user&.current_search || new_search
  end

  def cookoon_params
    params.require(:cookoon).permit(:name, :surface, :price, :address, :capacity, :category, photos: [])
  end

  def new_search
    UserSearch.new UserSearch.default_params
  end

  def filter_cookoons(user_search)
    # Here we can use @lat_lng to get user position
    # @lat_lng = cookies[:lat_lng].try(:split, "|")
    # requires to turn on scripts on pages
    base_scope = policy_scope(Cookoon).capacity_greater_than(user_search.people_count)
    if user_search.address.present?
      base_scope.near(user_search.address, UserSearch.default.radius)
    else
      base_scope.shuffled
    end
  end

  def build_markers
    @markers = @cookoons.map do |cookoon|
      { lat: cookoon.latitude, lng: cookoon.longitude }
    end
  end
end
