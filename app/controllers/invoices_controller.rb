class InvoicesController < ApplicationController
  skip_after_action :verify_authorized

  def create
    @reservation = Reservation.find(params[:reservation_id])
    # InvoiceMailer.new_request(@reservation).deliver_later
    flash[:notice] = 'Vous recevrez votre facture par e-mail très prochainement'
    redirect_to reservations_path
  end
end
