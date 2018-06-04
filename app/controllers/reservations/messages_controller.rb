class Reservations::MessagesController < ApplicationController
  before_action :find_reservation
  #TODO CP 4JUN Implement pundit when done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def new; end

  def create
    # redirect_to reservations_path, #flash: { payment_succeed: true }
  end

  private

  def find_reservation
    @reservation = Reservation.find params[:reservation_id]
  end
end
