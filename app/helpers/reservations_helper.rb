module ReservationsHelper
  def display_duration_for(reservation)
    "#{reservation.duration} heures"
  end

  def notifiable_reservations?
    return false unless current_user
    current_user.notifiable_reservations.any?
  end

  def notifiable_reservation_requests?
    return false unless current_user
    current_user.notifiable_reservation_requests.any?
  end
end
