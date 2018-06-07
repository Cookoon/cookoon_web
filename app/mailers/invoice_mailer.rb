class InvoiceMailer < ApplicationMailer
  def new_request(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    mail(to: '"Concierge Cookoon" <concierge@cookoon.fr>', from: @tenant.full_email, subject: "Nouvelle demande de Facture pour la réservation #{@reservation.id}") { |format| format.text }
  end
end
