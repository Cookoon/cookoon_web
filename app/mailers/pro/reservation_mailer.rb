module Pro
  class ReservationMailer < ApplicationMailer
    def proposed(reservation)
      @reservation = reservation
      @tenant = @reservation.quote.user
      mail(to: @tenant.full_email, subject: 'COOKOON · Votre proposition')
    end
  end
end
