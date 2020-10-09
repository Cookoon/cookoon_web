module ReservationsHelper
  def notifiable_reservations?
    return false unless current_user
    current_user.notifiable_reservations.any?
  end

  def notifiable_reservation_requests?
    return false unless current_user
    current_user.notifiable_reservation_requests.any?
  end

  # TODO CP 01/06 not the best approach here, foced to call html_safe in view
  def date_and_duration_display_for(reservation)
    date = l(reservation.start_at, format: '%d %B')
    time = l(reservation.start_at, format: '%H')
    "<b>#{date}</b>, à <b>#{time}h</b> pour <b>#{reservation.duration}h</b>"
  end
end
