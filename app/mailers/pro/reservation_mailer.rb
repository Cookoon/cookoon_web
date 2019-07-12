module Pro
  class ReservationMailer < ApplicationMailer
    include DatetimeHelper
    helper :datetime

    def proposed(reservation, message)
      @reservation = reservation
      @message = message
      @tenant = @reservation.user
      mail(to: @tenant.full_email, subject: 'Votre devis Cookoon est disponible !')
    end

    def accepted(reservation)
      @reservation = reservation
      @cookoon = @reservation.cookoon
      @tenant = @reservation.user

      mail(to: @tenant.full_email, subject: 'Votre évènement Cookoon est confirmé !')
    end

    def accepted_to_host(reservation)
      @reservation = reservation
      @cookoon = @reservation.cookoon
      @host = @cookoon.user

      mail(to: @host.full_email, subject: "L'évènement organisé dans votre Cookoon est confirmé !")
    end
  end
end
