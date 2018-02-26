class Payments::CreditCardsController < CreditCardsController
  private

  def handle_redirection(card)
    reservation = Reservation.find(params[:reservation_id])
    if card
      redirect_to new_reservation_payment_path(reservation)
    else
      redirect_to credit_cards_path, alert: @payment_service.displayable_errors
    end
  end
end
