class InvoiceMailer < ApplicationMailer
  def new_request(reservation)
    @reservation = reservation
    @tenant = @reservation.user
    mail(to: 'concierge@cookoon.fr', subject: 'Nouvelle demande de Facture') { |format| format.text }
  end
end
