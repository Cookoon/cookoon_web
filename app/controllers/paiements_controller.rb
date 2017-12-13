class PaiementsController < ApplicationController
  before_action :set_reservation

  def new
    paiement_service = StripePaymentService.new(
      user: current_user,
      reservation: @reservation
    )
    @user_cards = paiement_service.user_sources.try(:data)
  end

  def create
    paiement_service = StripePaymentService.new(
      user: @reservation.user,
      source: params[:paiement][:source],
      reservation: @reservation
    )

    if paiement_service.create_charge_and_update_reservation
      ReservationMailer.new_request(@reservation).deliver_now
      ReservationMailer.pending_request(@reservation).deliver_now
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
