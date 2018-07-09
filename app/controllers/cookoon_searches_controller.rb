class CookoonSearchesController < ApplicationController
  def create
    @cookoon_search = current_user.cookoon_searches.new(search_params)
    authorize @cookoon_search

    if @cookoon_search.save
      redirect_to cookoons_path
    else
      @error_message = "Attention : #{@cookoon_search.errors.full_messages.join('. ')}."
      render :new
    end
  end

  def update_all
    searches = current_user.active_recent_searches
    authorize searches

    searches.update_all(status: :inactive)
    redirect_to cookoons_path
  end

  private

  def search_params
    params.require(:cookoon_search).permit(:start_at, :duration, :people_count)
  end
end
