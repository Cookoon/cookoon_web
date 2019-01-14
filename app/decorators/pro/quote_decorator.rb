module Pro
  class QuoteDecorator < Draper::Decorator
    delegate_all
    decorates_association :reservations

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

    def estimated_price
      h.humanized_money_with_symbol object.estimated_price
    end
  end
end
