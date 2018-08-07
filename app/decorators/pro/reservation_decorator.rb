module Pro
  class ReservationDecorator < Draper::Decorator
    delegate_all

    def created_on(options = {})
      h.display_date_for(object.created_at, options)
    end

    def start_on(options = {})
      h.display_date_for(object.start_at, options)
    end

    def start_time
      h.display_time_for object.start_at
    end

    def end_time
      h.display_time_for object.end_at
    end

    def duration
      h.display_duration_for object.duration
    end

    def cookoon_price
      h.humanized_money_with_symbol object.cookoon_price
    end
  end
end
