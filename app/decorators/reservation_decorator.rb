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

  def start_on(options = {})
    h.display_date_for(object.start_at, options)
  end

  def default_type
    'Diner'
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

  def cookoon_price
    h.humanized_money_with_symbol object.cookoon_price
  end

  def cookoon_fee
    h.humanized_money_with_symbol object.cookoon_fee
  end

  def cookoon_fee_tax
    h.humanized_money_with_symbol object.cookoon_fee_tax
  end

  def services_tax
    h.humanized_money_with_symbol object.services_tax
  end

  def services_price
    h.humanized_money_with_symbol object.services_price
  end

  def services_full_price
    h.humanized_money_with_symbol object.services_full_price
  end

  def total_price
    h.humanized_money_with_symbol object.total_price
  end

  def total_full_price
    h.humanized_money_with_symbol object.total_full_price
  end

  def total_tax
    h.humanized_money_with_symbol object.total_tax
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
