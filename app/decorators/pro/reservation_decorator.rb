module Pro
  class ReservationDecorator < Draper::Decorator
    delegate_all
    decorates_association :services

    def title
      if object.status_before_type_cast < Reservation.statuses[:accepted]
        "Devis n°#{object.quote.id}"
      else
        "Réservation ##{object.id}"
      end
    end

    def subtitle
      if object.status_before_type_cast < Reservation.statuses[:accepted]
        "Votre demande de location pour le #{start_on(without_year: true)}, de #{start_time} à #{end_time}"
      else
        "Récapitulatif de votre location du #{start_on(without_year: true)}, de #{start_time} à #{end_time}"
      end
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

    def cookoon_fee_plus_tax
      h.humanized_money_with_symbol object.cookoon_fee_plus_tax
    end

    def cookoon_fee_tax
      h.humanized_money_with_symbol object.cookoon_fee_tax
    end

    def services_fee
      h.humanized_money_with_symbol object.services_fee
    end

    def services_price_plus_fee
      h.humanized_money_with_symbol object.services_price_plus_fee
    end

    def services_tax
      h.humanized_money_with_symbol object.services_tax
    end

    def services_price_plus_fee_plus_tax
      h.humanized_money_with_symbol object.services_price_plus_fee_plus_tax
    end

    def price_excluding_tax
      h.humanized_money_with_symbol object.price_excluding_tax
    end

    def price
      h.humanized_money_with_symbol object.price
    end
  end
end
