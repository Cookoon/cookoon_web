class EphemeralsController < ApplicationController
  before_action :find_ephemeral

  def show
    @credit_cards = current_user.credit_cards
    @reservation = Reservation.new(reservation_params)
  end

  private

  def find_ephemeral
    @ephemeral = Ephemeral.find params[:id]
    authorize @ephemeral
  end

  def reservation_params
    {
      user: current_user,
      cookoon: @ephemeral.cookoon,
      start_at: @ephemeral.start_at,
      duration: @ephemeral.duration,
      people_count: @ephemeral.people_count,
    }
  end
end
