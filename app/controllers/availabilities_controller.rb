class AvailabilitiesController < ApplicationController
  include Cookoons::AvailabilitiesBuilder

  skip_after_action :verify_policy_scoped

  def index
    @cookoon = Cookoon.includes(:future_availabilities).find(params[:cookoon_id])
    # authorize(@cookoon, :update?)
    authorize([:host, @cookoon], :update?)
    @weeks = build_weeks(Availability::SETTABLE_WEEKS_AHEAD)
    @cookoons = current_user.cookoons
  end

  def create
    @cookoon = Cookoon.find(params[:cookoon_id])
    # authorize(@cookoon, :update?)
    authorize([:host, @cookoon], :update?)
    @availability = @cookoon.availabilities.new(availability_params)
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

  def availability_params
    params.require(:availability).permit(:date, :time_slot)
  end
end
