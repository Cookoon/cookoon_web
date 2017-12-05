module ReservationsHelper
  def display_duration_for(reservation)
    "#{reservation.duration} heures"
  end

  def pending_reservations?
    return false unless current_user
    current_user.paid_reservations.any?
  end
end
