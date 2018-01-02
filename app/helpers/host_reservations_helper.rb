module HostReservationsHelper
  def reservations_list_or_empty_card(reservations)
    if reservations.any?
      render 'reservations_list', reservations: reservations
    else
      render 'no_reservation'
    end
  end
end
