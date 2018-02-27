class AvailabilitiesController < ApplicationController
  before_action :find_cookoon, only: %i[index create]
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped

  def index
    @weeks = build_weeks(3)
  end

  def create
  end

  def update
  end

  private

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end

  def build_weeks(nb_of_weeks = 1)
    weeks = []
    nb_of_weeks.times do |i|
      weeks << build_infos(Time.zone.today + i.weeks)
    end
    weeks
  end

  def build_infos(day_of_week)
    (day_of_week.beginning_of_week..day_of_week.end_of_week).to_a.map do |date|
      build_time_slots(date)
    end
  end

  def build_time_slots(date)
    Availability.time_slots.keys.map do |time_slot|
      {
        date: date,
        time_slot: time_slot
      }.merge(build_url(date, time_slot))
    end
  end

  def build_url(date, time_slot)
    # availability = @cookoon.availabilities.match_date_and_slot(date, time_slot).first
    if true # availability
      # { url: availability_path(availability), method: :patch, available: availability.available}
      { url: '/availabilities/1', method: :patch, available: false}
    else
      { url: cookoon_availabilities_path(@cookoon), method: :post, available: true}
    end
  end
end
