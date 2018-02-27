class AvailabilitiesController < ApplicationController
  before_action :find_cookoon, only: %i[index create]

  def index
  end

  def create
  end

  def update
  end

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end
end
