class ReservationMailer < ApplicationMailer
  include DatetimeHelper
  helper :datetime

  # ==== Tenant transaction =====
  def paid_request_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: 'Vous avez demandé un Cookoon !')
  end

  def confirmed_to_tenant(reservation)
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

  def refused_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Votre réservation Cookoon a été refusée : #{@cookoon.name}")
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

  def guests_overview_to_tenant(reservation_id)
    @reservation = Reservation.includes(reservation_guests: [:guest]).find(reservation_id)
    @tenant = @reservation.user
    mail(to: @tenant.full_email, subject: 'Vos convives ont bien été invités')
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

  # ==== Tenant Guest transaction =====
  def invitation_to_guest(reservation, guest)
    @reservation = reservation
    @guest = guest
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon

    attachments[@reservation.ical_file_name] = {
      mime_type: 'application/ics',
      content: @reservation.ical_for(:guest).to_ical
    }

    mail(
      to: @guest.full_email,
      subject: "#{@tenant.full_name} vous convie le #{display_date_for(@reservation.start_at)} à son événement !"
    )
  end


  # ==== Host transaction =====
  def paid_request_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "#{@tenant.first_name} souhaite louer votre Cookoon !")
  end

  def confirmed_to_host(reservation)
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
