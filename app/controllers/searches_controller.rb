class SearchesController < ApplicationController
  def create
    temp_params = {start_at: 3.days.from_now, people_count: 6, duration: 5}
    # TODO : Replace temp_params by search_params when done
    @search = current_user.searches.build(temp_params)
    authorize @search

    @search.save
    redirect_to cookoons_path
  end

  def update_all
    searches = current_user.active_recent_searches
    authorize searches

    searches.update_all(status: :inactive)
    redirect_to cookoons_path
  end

  private

  def search_params
    params.require(:search)
          .permit(:start_at, :duration, :people_count)
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
