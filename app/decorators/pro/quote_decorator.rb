class Pro::QuoteDecorator < Draper::Decorator
  delegate_all

  def start_at
    "le #{h.display_datetime_for(object.start_at, join_expression: 'à')}"
  end

  def duration
    "pour #{object.duration} heures"
  end

  def people_count
    "#{object.people_count} personnes"
  end
end
