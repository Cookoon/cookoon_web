class ReservationDecorator < Draper::Decorator
  delegate_all

  def recap_string
    "Votre maitre d'hotêl vous acceuillera le #{start_at.day} #{I18n.t('date.month_names')[start_at.month]} pour un #{type_name} à #{start_at.strftime('%HH%M')} avec #{people_count_text}"
  end

  def default_people_count
    10
  end

  def start_time
    h.display_time_for object.start_at
  end

  def end_time
    h.display_time_for object.end_at
  end

  def default_type
    'Brunch'
  end 

  def default_date
    'Votre choix'
  end

  def cookoon_owner_name
    object.cookoon.user.full_name
  end

  def people_count_text
    "#{object.people_count} convives"
  end
end
