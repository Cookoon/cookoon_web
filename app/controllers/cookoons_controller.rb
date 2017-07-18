class CookoonsController < ApplicationController
  def index
    @new_search = UserSearch.new(number: 1, duration: 1)
    @last_search = current_user.user_searches.last || @new_search
    @cookoons = Cookoon.near(@last_search.address || 'Paris' , 10)
    @search_infos = prepare_infos
    @hash = build_markers
  end

  def new
    @cookoon = Cookoon.new
  end

  def create
    @cookoon = Cookoon.new(cookoon_params)
    @cookoon.user = current_user
    if @cookoon.save
      redirect_to @cookoon
    else
      render :new
    end
  end

  def show
    @cookoon = Cookoon.find(params[:id])
  end

  private

  def cookoon_params
    params.require(:cookoon).permit(:name, :surface, :price, :address, :capacity, :category, photos: [])
  end

  def prepare_infos
    {
      position: @last_search.address || 'Autour de vous',
      time_slot: @last_search.datetime.try(:strftime, '%a %d - %H:%M') || 'Tout de suite',
      people_number: @last_search.number || 4
    }
  end

  def build_markers
    Gmaps4rails.build_markers(@cookoons) do |cookoon, marker|
      marker.lat cookoon.latitude
      marker.lng cookoon.longitude
    end
  end
end
