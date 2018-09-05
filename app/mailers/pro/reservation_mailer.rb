module Pro
  class ReservationMailer < ApplicationMailer
    include DatetimeHelper
    helper :datetime

    def proposed(reservation)
      @reservation = reservation
      @tenant = @reservation.user
      mail(to: @tenant.full_email, subject: 'Votre devis Cookoon est disponible !')
    end

    def accepted(reservation)
      @reservation = reservation
      @cookoon = @reservation.cookoon
      @tenant = @reservation.user

      attachments[@reservation.ical_file_name] = {
        mime_type: 'application/ics',
        content: @reservation.ical_for(:tenant).to_ical
      }

      mail(to: @tenant.full_email, subject: 'Votre évènement Cookoon est confirmé !')
    end
  end
end
