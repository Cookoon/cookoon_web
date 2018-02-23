class Payments::CreditCardsController < ApplicationController
  # Try a better approach than skiping once done
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  before_action :set_payment_service

  def create
    reservation = Reservation.find(params[:reservation_id])
    card = @payment_service.add_source_to_customer
    @payment_service.default_card(card) if params[:credit_card][:default] == '1'
    if card
      redirect_to new_reservation_payment_path(reservation)
    else
      redirect_to credit_cards_path, alert: @payment_service.displayable_errors
    end
  end

  private

  def set_payment_service
    @payment_service = StripePaymentService.new(
      user: current_user,
      token: params.dig(:credit_card, :stripe_token)
    )
  end
end
