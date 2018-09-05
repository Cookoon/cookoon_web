module Pro
  class ReservationMailer < ApplicationMailer
    include DatetimeHelper
    helper :datetime

    def proposed(reservation)
      @reservation = reservation
      @tenant = @reservation.quote.user
      mail(to: @tenant.full_email, subject: 'Votre devis Cookoon est disponible !')
    end
  end
end
