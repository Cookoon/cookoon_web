class ReservationMailer < ApplicationMailer
  # ==== Mails for Users =====
  def new_request(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Vous avez demandé un Cookoon !')
  end

  def cancelled_request(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location Cookoon a bien été annulée')
  end

  def confirmed_by_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon est confirmée : #{@cookoon.name}")
  end

  def refused_by_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon a été refusée : #{@cookoon.name}")
  end

  def ending_survey_for_user(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Comment s’est passée votre expérience Cookoon ?")
  end
  # ============================

  # ==== Mails for Host =====
  def pending_request(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "#{@tenant.first_name} souhaite louer votre Cookoon !")
  end

  def cancelled_by_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "La location Cookoon de #{@tenant.first_name} a été annulée")
  end

  def confirmation(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Vous avez confirmé une demande de location !")
  end

  def ending_survey_for_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Comment s’est passée votre expérience Cookoon ?")
  end
  # ============================
end
