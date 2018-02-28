module AvailabilitiesBuilder
  include DatetimeHelper

  private

  def build_weeks(nb_of_weeks = 1)
    weeks = []
    nb_of_weeks.times do |i|
      weeks << build_week(Time.zone.today + i.weeks)
    end
    weeks
  end

  def build_time_slot(attrs = {})
    availability = @availability || @cookoon.availabilities.find_by(attrs)
    if availability
      { url: availability_path(availability), method: :patch, available: availability.available }
    else
      { url: cookoon_availabilities_path(@cookoon), method: :post, available: true }
    end.merge(attrs)
  end

  def build_week(day_of_week)
    first_day = day_of_week.beginning_of_week
    last_day = day_of_week.end_of_week

    {
      display: "Semaine du #{display_date_for(first_day)}",
      days: build_days(first_day, last_day)
    }
  end

  def build_days(first_day, last_day)
    (first_day..last_day).to_a.map do |day|
      {
        display: display_date_for(day, without_year: true, with_weekda: true).capitalize,
        time_slots: build_time_slots(day)
      }
    end
  end

  def build_time_slots(day)
    Availability.time_slots.keys.map do |time_slot|
      build_time_slot(date: day, time_slot: time_slot)
    end
  end
end
