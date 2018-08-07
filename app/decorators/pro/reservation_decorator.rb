module Pro
  class ReservationDecorator < Draper::Decorator
    delegate_all

    def created_on(options = {})
      h.display_date_for(object.created_at, options)
    end

    def start_at
      "le #{h.display_datetime_for(object.start_at, join_expression: 'à')}"
    end

    def start_on(options = {})
      h.display_date_for(object.start_at, options)
    end

    def duration
      "pour #{object.duration} heures"
    end

    def people_count
      "#{object.people_count} personnes"
    end
  end
end
