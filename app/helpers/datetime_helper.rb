module DatetimeHelper
  def display_datetime_for(datetime, attrs = {})
    datetime_array = [display_date_for(datetime, attrs)]
    datetime_array << attrs[:join_expression]
    datetime_array << display_time_for(datetime, attrs)
    datetime_array.join(' ')
  end

  def display_date_for(datetime, attrs = {})
    format = attrs[:without_year] ? '%A %d %B' : '%A %d %B %Y'
    l(datetime, format: format)
  end

  def display_time_for(datetime, attrs = {})
    if datetime.hour == 0 && datetime.min == 0 && datetime.sec == 0
      "minuit"
    elsif datetime.hour == 12 && datetime.min == 0 && datetime.sec == 0
      "midi"
    else
      time_separator = attrs[:time_separator] || 'h'
      l(datetime, format: "%k#{time_separator}%M")
    end
  end

  def display_duration_for(duration)
    duration == 1 ? "#{duration} heure" : "#{duration} heures"
  end
end
