class ReservationMailer < ApplicationMailer
  include DatetimeHelper
  helper :datetime

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

    attachments[@reservation.ical_file_name] = {
      mime_type: 'application/ics',
      content: @reservation.ical_for(:tenant).to_ical
    }
    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon est confirmée : #{@cookoon.name}")
  end

  def refused_by_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon a été refusée : #{@cookoon.name}")
  end

  def cancelled_by_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location de Cookoon a été annulée')
  end

  def ending_survey_for_user(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  end

  def invitations_sent(reservation)
    @reservation = reservation
    @guests = @reservation.guests
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Vos convives ont bien été invités')
  end
  # ============================

  # ==== Mails for Tenant Guests =====
  def invited_by_tenant(reservation, guest)
    @reservation = reservation
    @guest = guest
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user

    attachments[@reservation.ical_file_name] = {
      mime_type: 'application/ics',
      content: @reservation.ical_for(:guest).to_ical
    }

    mail(
      to: @guest.full_email,
      subject: "#{@tenant.full_name} vous convie le #{display_date_for(@reservation.date)} à son événement !"
    )
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

  def waiting_host_answer_for_one_day(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Rappel: #{@tenant.first_name} souhaite louer votre Cookoon !")
  end

  def cancelled_by_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "La location Cookoon de #{@tenant.first_name} a été annulée")
  end

  def cancelled_reservation(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: 'La location Cookoon a bien été annulée')
  end

  def confirmation(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user

    attachments[@reservation.ical_file_name] = {
      mime_type: 'application/ics',
      content: @reservation.ical_for(:host).to_ical
    }

    mail(to: @host.full_email, subject: 'Vous avez confirmé une demande de location !')
  end

  def ending_survey_for_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  end
  # ============================

  # ==== Notifications =====
  def notify_tenant_before_reservation(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Votre location Cookoon se rapproche !')
  end
  # ============================
end
