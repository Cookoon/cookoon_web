class UserSearchesController < ApplicationController
  def create
    @user_search = current_user.user_searches.build(user_search_params)
    authorize @user_search

    @user_search.save
    redirect_to cookoons_path
  end

  def update_all
    user_searches = current_user.active_recent_searches
    authorize user_searches

    user_searches.update_all(status: :inactive)
    redirect_to cookoons_path
  end

  private

  def user_search_params
    params.require(:user_search)
          .permit(:address, :start_at, :duration, :people_count)
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
