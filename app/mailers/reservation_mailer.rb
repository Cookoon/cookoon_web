class ReservationMailer < ApplicationMailer
  include DatetimeHelper
  helper :datetime

  # ==== Amex transaction =====
  def amex_request_to_amex(reservation)
    @reservation = reservation
    @tenant = @reservation.amex_code
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    # mail(to: "Justine.Plaisance1@aexp.com; julien.b.stumpf@aexp.com", subject: "Cookoon: nouvelle demande de réservation - #{@tenant.first_name.capitalize} #{@tenant.last_name.capitalize}")
    if Rails.env.staging?
      mail(to: "alice.fabre@hotmail.fr", subject: "Cookoon: nouvelle demande de réservation - #{@tenant.first_name.capitalize} #{@tenant.last_name.capitalize}")
    elsif Rails.env.production?
      mail(to: "alicefabre1984@gmail.com", subject: "Cookoon: nouvelle demande de réservation - #{@tenant.first_name.capitalize} #{@tenant.last_name.capitalize}")
    end
  end


  # ==== Tenant transaction =====
  # def paid_request_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Vous avez demandé un Cookoon !')
  # end

  def amex_host_confirmation_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.amex_code
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre réservation est confirmée pour \"#{@cookoon.name}\"")
  end

  def amex_request_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.amex_code
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre demande de réservation pour \"#{@cookoon.name}\"")
  end

  def paid_request_cookoon_butler_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre demande de réservation pour \"#{@cookoon.name}\"")
  end

  def paid_confirmation_cookoon_butler_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre réservation est confirmée pour \"#{@cookoon.name}\"")
  end

  def paid_request_menu_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre menu dans le cadre de votre réservation pour \"#{@cookoon.name}\" est confirmé")
  end

  def paid_confirmation_menu_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre paiement pour le chef et les menus dans le cadre de votre réservation pour \"#{@cookoon.name}\" est confirmé")
  end

  def paid_request_services_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: vos services additionnels dans le cadre de votre réservation pour \"#{@cookoon.name}\" sont confirmés")
  end

  def paid_confirmation_services_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre paiement pour les services additionnels dans le cadre de votre réservation pour \"#{@cookoon.name}\" est confirmé")
  end

  def quotation_request_to_tenant(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @tenant.full_email, subject: "Cookoon: votre demande de devis pour \"#{@cookoon.name}\"")
  end

  # def refused_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: "Votre demande de location n'a pas pu être validée, faites une autre réservation !")
  # end

  # def cancelled_by_tenant_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Votre location Cookoon a bien été annulée')
  # end

  # def cancelled_by_host_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Votre location de Cookoon a été annulée')
  # end

  # def ending_survey_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   mail(to: @tenant.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  # end

  # ==== Tenant notification =====
  # def notify_approaching_reservation_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Votre location Cookoon se rapproche !')
  # end

  # def notify_approaching_reservation_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: 'La location de votre Cookoon se rapproche !')
  # end

  # def autocancel_short_notice_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  # end

  # def autocancel_stripe_period_to_tenant(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  # end

  # ==== Host transaction =====
  # def paid_request_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: "#{@tenant.first_name} souhaite louer votre Cookoon !")
  # end

  def amex_host_confirmation_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.amex_code
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez confirmé la demande de réservation pour \"#{@cookoon.name}\"")
  end

  def amex_request_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.amex_code
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez une demande de réservation pour \"#{@cookoon.name}\"")
  end

  def paid_request_cookoon_butler_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez une demande de réservation pour \"#{@cookoon.name}\"")
  end

  def paid_confirmation_cookoon_butler_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez confirmé la demande de réservation pour \"#{@cookoon.name}\"")
  end

  def quotation_request_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez une demande de réservation pour \"#{@cookoon.name}\"")
  end

  def quotation_host_confirmation_to_host(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    @cookoon = @reservation.cookoon
    @host = @cookoon.user
    mail(to: @host.full_email, subject: "Cookoon: vous avez confirmé la demande de réservation pour \"#{@cookoon.name}\"")
  end

  # def cancelled_by_tenant_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: "La location Cookoon de #{@tenant.first_name} a été annulée")
  # end

  # def cancelled_by_host_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: 'La location Cookoon a bien été annulée')
  # end

  # def ending_survey_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: "Comment s'est passée votre expérience Cookoon ?")
  # end

  # def notify_payout_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: 'Votre paiement Cookoon a bien été effectué')
  # end

  # ==== Host notification =====
  # def notify_awaiting_request_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @host.full_email, subject: "Rappel: #{@tenant.first_name} souhaite louer votre Cookoon !")
  # end

  # def autocancel_stripe_period_to_host(reservation)
  #   @reservation = reservation
  #   @tenant = @reservation.user
  #   @cookoon = @reservation.cookoon
  #   @host = @cookoon.user
  #   mail(to: @tenant.full_email, subject: 'Votre demande de location de Cookoon a été annulée')
  # end
end
