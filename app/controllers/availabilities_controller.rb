class AvailabilitiesController < ApplicationController
  include AvailabilitiesBuilder

  skip_after_action :verify_policy_scoped
  before_action :find_cookoon, only: %i[index create]

  def index
    authorize(@cookoon, :update?)
    @weeks = build_weeks(3)
  end

  def create
    @availability = @cookoon.availabilities.new(availability_params)
    authorize @availability
    @availability.save
    render json: build_time_slot
  end

  def update
    @availability = Availability.find(params[:id])
    authorize @availability
    @availability.update(available: !@availability.available)
    render json: build_time_slot
  end

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end

  def availability_params
    params.require(:availability).permit(:date, :time_slot)
  end
end
