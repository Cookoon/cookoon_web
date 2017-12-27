class InvoicesController < ApplicationController
  skip_after_action :verify_authorized
  
  def create
    @reservation = Reservation.find(params[:reservation_id])
  end
end
