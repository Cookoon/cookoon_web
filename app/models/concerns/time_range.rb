module TimeRange
  extend ActiveSupport::Concern
  class_methods do
    def day_range(date_time)
      date_time.beginning_of_day..date_time.end_of_day
    end

    def hour_range(date_time)
      date_time.beginning_of_hour..date_time.end_of_hour
    end
  end
end
