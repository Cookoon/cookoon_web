module DatetimeHelper
  def display_datetime_for(datetime, attrs = {})
    datetime_array = [display_date_for(datetime)]
    datetime_array << attrs[:join_expression]
    datetime_array << display_time_for(datetime)
    datetime_array.join(' ')
  end

  def display_date_for(datetime)
    l(datetime, format: '%-d %B %Y')
  end

  def display_time_for(datetime)
    l(datetime, format: '%kh%M')
  end
end
