class ChefsController < ApplicationController
  before_action :find_reservation, only: %i[index]

  def index
    @chefs = policy_scope(Chef).includes(:menus)
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end
end