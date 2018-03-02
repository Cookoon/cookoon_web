class UserSearchesController < ApplicationController
  before_action :find_user_search, only: [:update, :destroy]

  def create
    @user_search = current_user.user_searches.build(user_search_params)
    authorize @user_search

    @user_search.save
    redirect_to cookoons_path
  end

  def update
    @user_search.update(user_search_params)
    redirect_to cookoons_path
  end

  def destroy
    @user_search.inactive!
    redirect_to cookoons_path
  end

  private

  def find_user_search
    @user_search = UserSearch.find(params[:id])
    authorize @user_search
  end

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
