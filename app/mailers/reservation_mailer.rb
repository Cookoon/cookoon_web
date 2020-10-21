class ReservationMailer < ApplicationMailer
  include DatetimeHelper
  helper :datetime

  # ==== Tenant transaction =====
  # def paid_request_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Vous avez demandé un Cookoon !')
  # end

  def paid_request_cookoon_butler_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre demande de réservation')
  end

  def confirmed_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user

    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon est confirmée : #{@cookoon.name}")
  end

  def refused_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Votre demande de location n'a pas pu être validée, faites une autre réservation !")
  end

  def cancelled_by_tenant_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location Cookoon a bien été annulée')
  end

  def cancelled_by_host_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location de Cookoon a été annulée')
  end

  def ending_survey_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    mail(to: @tenant.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  end

  # ==== Tenant notification =====
  def notify_approaching_reservation_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location Cookoon se rapproche !')
  end

  def notify_approaching_reservation_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: 'La location de votre Cookoon se rapproche !')
  end

  def autocancel_short_notice_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  end

  def autocancel_stripe_period_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  end

  # ==== Host transaction =====
  # def paid_request_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: "#{@tenant.first_name} souhaite louer votre Cookoon !")
  # end

  def paid_request_cookoon_butler_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: 'Vous avez une demande de réservation')
  end

  def confirmed_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user

    mail(to: @host.full_email, subject: 'Vous avez confirmé une demande de location !')
  end

  def cancelled_by_tenant_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "La location Cookoon de #{@tenant.first_name} a été annulée")
  end

  def cancelled_by_host_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: 'La location Cookoon a bien été annulée')
  end

  def ending_survey_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  end

  def notify_payout_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: 'Votre paiement Cookoon a bien été effectué')
  end

  # ==== Host notification =====
  def notify_awaiting_request_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Rappel: #{@tenant.first_name} souhaite louer votre Cookoon !")
  end

  def autocancel_stripe_period_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  end
end
