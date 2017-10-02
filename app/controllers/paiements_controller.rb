class PaiementsController < ApplicationController
  before_action :set_reservation

  def new
  end

  def create
    paiement_service = StripePaiementService.new(
      user: current_user,
      token: params[:stripe_token],
      reservation: @reservation
    )

    if paiement_service.create_charge_and_update_reservation
      redirect_to cookoons_path, flash: { paiement_succeed: true }
    else
      flash[:alert] = paiement_service.displayable_errors
      render :new
    end
  end

  private

  def set_reservation
    @reservation = Reservation.where(status: :pending).find(params[:reservation_id])
    authorize @reservation
  end
end
