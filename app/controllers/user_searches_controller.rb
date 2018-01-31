class UserSearchesController < ApplicationController
  def create
    @search = current_user.user_searches.build(search_params)
    authorize @search
    @search.save
    redirect_to cookoons_path
  end

  private

  def search_params
    params.require(:user_search)
          .permit(:address, :date, :number, :duration)
          .delocalize(date: :time)
  end
end
