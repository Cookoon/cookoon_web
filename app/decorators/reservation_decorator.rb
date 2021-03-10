class ReservationDecorator < Draper::Decorator
  delegate_all

  def recap_string
    if amex?
      begin_of_sentence = "Vous serez accueilli" if start_at >= Date.today
      begin_of_sentence = "Vous avez été accueilli" if start_at < Date.today
    else
      begin_of_sentence = "Vos maitres d'hôtel vous accueilleront" if start_at >= Date.today && butler_count > 1
      begin_of_sentence = "Votre maitre d'hôtel vous accueillera" if start_at >= Date.today && butler_count == 1
      begin_of_sentence = "Vos maitres d'hôtel vous ont accueilli" if start_at < Date.today && butler_count > 1
      begin_of_sentence = "Votre maitre d'hôtel vous a accueilli" if start_at < Date.today && butler_count == 1
    end
    "#{begin_of_sentence} le #{start_on} pour votre #{humanized_type_name} à #{start_time} de #{people_count_text}."
  end

  def recap_string_without_day_and_people_count
    if amex?
      ("Vous serez accueillis à <strong>#{start_time}</strong>.").html_safe
    else
      if butler_count > 1
        ("Vos maitres d'hôtel vous accueilleront à <strong>#{start_time}</strong>.").html_safe
      else
        ("Votre maitre d'hôtel vous accueillera à <strong>#{start_time}</strong>.").html_safe
      end
    end
  end

  def recap_string_end_time
    start_at >= Date.today ? verb = "se prolongera" : verb = "s'est prolongée"
    "Votre réception #{verb} jusqu'à #{end_time}."
  end

  def recap_string_end_time_with_bolded_time
    ("Votre réception se prolongera jusqu'à <strong>#{end_time}</strong>.").html_safe
  end

  def recap_string_start_and_end_time
    if amex?
      begin_of_sentence = "Votre décor vous ouvrira ses portes" if start_at >= Date.today
      begin_of_sentence = "Votre décor vous a ouvert ses portes" if start_at < Date.today
      end_of_sentence = "se prolongera jusqu’à " if start_at >= Date.today
      end_of_sentence = "s'est prolongé jusqu’à " if start_at < Date.today
      "#{begin_of_sentence} à #{start_time}. Votre #{humanized_type_name} #{end_of_sentence} #{end_time}."
    else
    "Votre décor de #{start_time} à #{end_time} (mise à disposition pour le chef et le service de #{start_time_for_chef_and_service} à #{end_time_for_chef_and_service})"
    end
  end

  def recap_string_butler_count
    butler_count == 1 ? butler = "maître d'hôtel" : butler = "maîtres d'hôtel"
    "Votre service assuré par #{butler_count.humanize} #{butler}."
  end

  def default_people_count
    8
  end

  def start_time
    h.display_time_for object.start_at
  end

  def end_time
    h.display_time_for object.end_at
  end

  def start_time_for_chef_and_service
    h.display_time_for object.start_at_for_chef_and_service
  end

  def end_time_for_chef_and_service
    h.display_time_for object.end_at_for_chef_and_service
  end

  def start_on(options = {})
    h.display_date_for(object.start_at, options)
  end

  def default_type
    if amex?
      ['Dîner', 'amex_diner']
    else
      ['Dîner', 'diner']
    end
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

  def cookoon_butler_full_price_without_cents
    h.money_without_cents_and_with_symbol object.cookoon_butler_with_tax
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

  def services_collection_for_view_with_sentence_if_not_quoted
    # Can filter depending on reservation type
    {
      sommelier: "La présence d'un sommelier",
      parking: "Le service voiturier",
      corporate: "Les #{people_count} kits professionnels",
      catering: "Les #{people_count} plateaux repas",
      flowers: "Une composition florale - Notre concierge vous contactera afin de recueillir vos attentes",
      wine: "La carte des vins - Notre sommelier vous contactera afin de vous accompagner dans le choix des vins"
    }
  end

  def services_collection_for_view_with_sentence_if_quoted
    # Can filter depending on reservation type
    {
      sommelier: "La présence d'un sommelier",
      parking: "Le service voiturier",
      corporate: "Les #{people_count} kits professionnels",
      catering: "Les #{people_count} plateaux repas",
      flowers: "Une composition florale",
      wine: "La carte des vins"
    }
  end

  def services_collection_for_event_type
    case object.type_name
      # when 'breakfast'
      # when 'brunch'
      when 'lunch', 'diner', 'diner_cocktail', 'lunch_cocktail'
        [
          [services_collection_for_view_with_sentence_if_not_quoted[:parking], :parking],
          [services_collection_for_view_with_sentence_if_not_quoted[:flowers], :flowers],
          [services_collection_for_view_with_sentence_if_not_quoted[:wine], :wine]
        ]
      # when 'morning', 'afternoon'
      # when 'day'
      end
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
      diner_cocktail: 'cocktail dînatoire',
      lunch_cocktail: 'cocktail déjeunatoire',
      morning: 'matinée',
      day: 'journée',
      afternoon: 'après-midi',
      brunch: 'brunch',
      amex_diner: 'dîner',
      amex_lunch: 'déjeuner',
    }
  end

  def humanized_type_name
    type_names[object.type_name.to_sym]
  end

  def humanized_type_name_with_pronom
    type_name == "morning" || type_name == "day" ? pronom = "une" : pronom = "un"
    "#{pronom} #{humanized_type_name}"
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
