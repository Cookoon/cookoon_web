module Pro
  class ReservationDecorator < Draper::Decorator
    delegate_all
    decorates_association :services

    def title
      if object.quotation?
        "Devis #{object.quote_reference}"
      elsif object.ongoing?
        "Réservation ##{object.id}\nselon devis #{object.quote_reference}"
      else
        "Facture #{object.invoice_reference}\nselon devis #{object.quote_reference}"
      end
    end

    def subtitle
      if object.quotation?
        "Votre demande de location pour le #{start_on(without_year: true)}, de #{start_time} à #{end_time}"
      else
        "Récapitulatif de votre location du #{start_on(without_year: true)}, de #{start_time} à #{end_time}"
      end
    end

    def pdf_file_name
      if object.quotation?
        "#{object.quote_reference}_COOKOON_#{object.company.name.parameterize(separator: '_').upcase}"
      else
        "#{object.invoice_reference}_COOKOON_#{object.company.name.parameterize(separator: '_').upcase}"
      end
    end

    def invoice_legal_mentions
      <<~LEGAL_MENTIONS
        Délai de règlement : #{1.month.since(start_at).strftime('%d/%m/%Y')}
        Moyen de règlement : Virement

        Banque : #{object.company.sepa_infos.bank_name}
        BIC : #{object.company.sepa_infos.bic}
        IBAN : #{object.company.sepa_infos.iban}
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

    def cookoon_fee
      h.humanized_money_with_symbol object.cookoon_fee
    end

    def cookoon_fee_tax
      h.humanized_money_with_symbol object.cookoon_fee_tax
    end

    def services_fee
      h.humanized_money_with_symbol object.services_fee
    end

    def services_price_with_fee
      h.humanized_money_with_symbol object.services_price_with_fee
    end

    def services_tax
      h.humanized_money_with_symbol object.services_tax
    end

    def services_price_full
      h.humanized_money_with_symbol object.services_price_full
    end

    def price_excluding_tax
      h.humanized_money_with_symbol object.price_excluding_tax
    end

    def price
      h.humanized_money_with_symbol object.price
    end
  end
end
