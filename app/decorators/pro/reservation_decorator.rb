module Pro
  class ReservationDecorator < Draper::Decorator
    delegate_all
    decorates_association :services

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

    def services_price
      h.humanized_money_with_symbol object.services_price
    end

    def fee
      h.humanized_money_with_symbol object.fee
    end

    def price
      h.humanized_money_with_symbol object.price
    end
  end
end