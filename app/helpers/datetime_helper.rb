module DatetimeHelper
  def display_datetime_for(datetime, attrs = {})
    datetime_array = [display_date_for(datetime, attrs)]
    datetime_array << attrs[:join_expression]
    datetime_array << display_time_for(datetime, attrs)
    datetime_array.join(' ')
  end

  def display_date_for(datetime, attrs = {})
    format = attrs[:without_year] ? '%-d %B' : '%-d %B %Y'
    l(datetime, format: format)
  end

  def display_time_for(datetime, attrs = {})
    time_separator = attrs[:time_separator] || 'h'
    l(datetime, format: "%k#{time_separator}%M")
  end
end
