class AvailabilitiesController < ApplicationController
  include DatetimeHelper
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
      weeks << build_week(Time.zone.today + i.weeks)
    end
    weeks
  end

  def build_week(day_of_week)
    first_day = day_of_week.beginning_of_week
    last_day = day_of_week.end_of_week

    {
      display: "Semaine du #{build_display_week(first_day, last_day)}",
      days: build_days(first_day, last_day)
    }
  end

  def build_display_week(first_day, last_day)
    [first_day, last_day].map do |day|
      display_date_for(day, without_year: true)
    end.join(' au ')
  end

  def build_days(first_day, last_day)
    (first_day..last_day).to_a.map do |day|
      {
        display: display_date_for(day, without_year: true),
        time_slots: build_time_slots(day)
      }
    end
  end

  def build_time_slots(day)
    Availability.time_slots.keys.map do |time_slot|
      {
        date: day,
        time_slot: time_slot
      }.merge(build_url(day, time_slot))
    end
  end

  def build_url(day, time_slot)
    # availability = @cookoon.availabilities.match_date_and_slot(day, time_slot).first
    if true # availability
      # { url: availability_path(availability), method: :patch, available: availability.available}
      { url: '/availabilities/1', method: :patch, available: false}
    else
      { url: cookoon_availabilities_path(@cookoon), method: :post, available: true}
    end
  end
end
