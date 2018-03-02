class UserSearchesController < ApplicationController
  def create
    @search = current_user.user_searches.build(search_params)
    authorize @search
    @search.save
    redirect_to cookoons_path
  end

  def update
    @new_search = @user_search = UserSearch.new(people_count: 2, duration: 2, start_at: (Time.zone.now + 3.days).beginning_of_hour)
    @cookoons = policy_scope(Cookoon).shuffled
    build_markers

    @search_infos = { position: 'Adresse', time_slot: 'Tout de suite', people_count: 2 }
    searches = current_user.active_recent_searches
    authorize searches
    searches.update_all(status: :inactive)
  end

  private

  def search_params
    params.require(:user_search)
          .permit(:address, :start_at, :people_count, :duration)
          .delocalize(start_at: :time)
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
