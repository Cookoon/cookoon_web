class ReservationDecorator < Draper::Decorator
  delegate_all

  def recap_string
    "Votre maitre d'hôtel vous accueillera le #{start_at.day} #{I18n.t('date.month_names')[start_at.month]} pour un #{type_name} à #{start_at.strftime('%HH%M')} avec #{people_count_text}"
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

  def services_collection_for_view
    # Can filter depending on reservation type
    [
      ['Sommelier', :sommelier],
      ['Voiturier', :parking],
      ['Kit professionnel', :corporate],
      ['Plateaux repas', :catering]
    ]
  end

  def type_names
    {
      breakfast: 'Petit déjeuner',
      lunch: 'Déjeuner',
      diner: 'Dîner',
      cocktail: 'Cocktail',
      morning: 'Matinée',
      day: 'Journée',
      afternoon: 'Après-midi',
      brunch: 'Brunch'
    }
  end

  def humanized_type_name
    type_names[object.type_name.to_sym]
  end

  def builtin_services
    if object.services.where(category: [:sommelier, :parking, :corporate, :catering]).any?
      object.services.pluck(:category)
    else
      case object.type_name
      when 'breakfast'
        [:corporate]
      when 'brunch'
        [:sommelier]
      when 'lunch', 'diner', 'cocktail'
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