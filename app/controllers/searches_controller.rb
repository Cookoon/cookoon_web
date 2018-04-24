class SearchesController < ApplicationController
  def create
    @search = current_user.searches.build(search_params)
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
