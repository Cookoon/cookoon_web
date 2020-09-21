class ReservationDecorator < Draper::Decorator
  delegate_all

  def recap_string
    # "Votre maitre d'hôtel vous accueillera le #{start_at.day} #{I18n.t('date.month_names')[start_at.month]} pour un #{type_name} à #{start_at.strftime('%HH%M')} avec #{people_count_text}"
    humanized_type_name == "Journée" ? pronom = "une" : pronom = "un"
    "Votre maitre d'hôtel vous accueillera le #{I18n.l start_at, format: '%A %d %B'} pour #{pronom} #{humanized_type_name} à #{start_at.strftime('%kH%M')} de #{people_count_text}."
  end

  def recap_string_end_time
    end_at.strftime('%kH%M') == " 0H00" ? end_at_time = "minuit" : end_at_time = end_at.strftime('%kH%M')
    "Votre réception se prolongera jusqu'à #{end_at_time}."
  end

  def recap_string_start_and_end_time
    end_at.strftime('%kH%M') == " 0H00" ? end_at_time = "minuit" : end_at_time = end_at.strftime('%kH%M')
    # "Votre décor de #{start_at.strftime('%kH%M')} à #{end_at_time}."
    "Votre décor de #{start_at.strftime('%kH%M')} à #{end_at_time} (mise à disposition pour le chef et le service de #{start_at_for_chef_and_service.strftime('%kH%M')} à #{end_at_for_chef_and_service.strftime('%kH%M')})"
  end

  def recap_string_butler_count
    butler_count == 1 ? butler = "maître d'hôtel" : butler = "maîtres d'hôtel"
    "Votre service assuré par #{butler_count.humanize} #{butler}."
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

  def start_on(options = {})
    h.display_date_for(object.start_at, options)
  end

  def default_type
    ['Dîner', 'diner']
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

  def duration
    h.display_duration_for object.duration
  end

  def total_full_price_per_person
    object.total_with_tax / object.people_count
  end

  def cookoon_price
    h.humanized_money_with_symbol object.cookoon_price
  end

  def services_tax
    h.humanized_money_with_symbol object.services_tax
  end

  def services_price
    h.humanized_money_with_symbol object.services_price
  end

  def services_full_price
    h.humanized_money_with_symbol object.services_with_tax
  end

  def total_price
    h.humanized_money_with_symbol object.total_price
  end

  def total_full_price
    h.humanized_money_with_symbol object.total_with_tax
  end

  def total_tax
    h.humanized_money_with_symbol object.total_tax
  end

  def menu_price
    h.humanized_money_with_symbol object.menu_price
  end

  def menu_tax
    h.humanized_money_with_symbol object.menu_tax
  end

  def menu_full_price
    h.humanized_money_with_symbol object.menu_with_tax
  end

  def cookoon_butler_price
    h.humanized_money_with_symbol object.cookoon_butler_price
  end

  def cookoon_butler_tax
    h.humanized_money_with_symbol object.cookoon_butler_tax
  end

  def cookoon_butler_full_price
    h.humanized_money_with_symbol object.cookoon_butler_with_tax
  end

  def butler_price
    h.humanized_money_with_symbol object.butler_price
  end

  def butler_tax
    h.humanized_money_with_symbol object.butler_tax
  end

  def butler_full_price
    h.humanized_money_with_symbol object.butler_with_tax
  end

  def services_collection_for_view
    # Can filter depending on reservation type
    [
      ['Sommelier', :sommelier],
      ['Voiturier', :parking],
      ['Kit professionnel', :corporate],
      ['Plateaux repas', :catering],
      ['Composition florale', :flowers],
      ['Vin', :wine]
    ]
  end

  def services_collection_available_for_view
    services_affected = builtin_services.map {|element| element.to_sym}
    services_collection_for_view.delete_if {|element| services_affected.include?(element[1]) unless element[1] == "wine".to_sym }
  end

  def type_names
    {
      breakfast: 'petit-déjeuner',
      lunch: 'déjeuner',
      diner: 'dîner',
      diner_cocktail: 'cocktail dînatoire)',
      lunch_cocktail: 'cocktail déjeunatoire',
      morning: 'matinée',
      day: 'journée',
      afternoon: 'après-midi',
      brunch: 'brunch'
    }
  end

  def humanized_type_name
    type_names[object.type_name.to_sym]
  end

  def builtin_services
    if object.services.where(category: [:sommelier, :parking, :corporate, :catering, :flowers, :wine]).any?
      object.services.pluck(:category)
    else
      case object.type_name
      when 'breakfast'
        [:corporate]
      when 'brunch'
        [:sommelier]
      when 'lunch', 'diner', 'diner_cocktail', 'lunch_cocktail'
        [:sommelier, :parking]
      when 'morning', 'afternoon'
        [:corporate, :catering]
      when 'day'
        [:sommelier, :corporate, :catering]
      end
    end
  end

  def invoice_legal_mentions
    return unless object.user.company
    <<~LEGAL_MENTIONS
      Délai de règlement : #{1.month.since(start_at).strftime('%d/%m/%Y')}
      Moyen de règlement : Virement

      Banque : #{object.user.company.stripe_bank_name}
      BIC : #{object.user.company.stripe_bic}
      IBAN : #{object.user.company.stripe_iban}
    LEGAL_MENTIONS
  end

  def quotation_cancel_policy
    <<-CANCEL_POLICY
      Conditions d’annulation

      Gratuit plus de 6 jours ouvrés avant le début de la mise à disposition
      50% du montant total entre 6 et 3 jours ouvrés avant le début de la mise à disposition
      100 % du montant total moins de 3 jours ouvrés avant le début de la mise à disposition
    CANCEL_POLICY
  end
end
