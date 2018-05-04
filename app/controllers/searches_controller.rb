class SearchesController < ApplicationController
  def create
    @search = current_user.searches.new(search_params)
    authorize @search

    if @search.save
      redirect_to cookoons_path
    else
      @error_message = "Attention : #{@search.errors.full_messages.join('. ')}."
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
    params.require(:search).permit(:start_at, :duration, :people_count)
  end
end
