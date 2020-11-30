class UnChefPourVous::ReservationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    @reservation = Reservation.new(reservation_params.merge(category: 'amex', people_count: 2))
    if @reservation.save
      redirect_to un_chef_pour_vous_reservation_cookoons_path(@reservation)
    else
      flash.alert = "Votre réservation n'est pas valide, vous devez remplir tous les champs."
      redirect_to un_chef_pour_vous_root_path
    end
  end

  def reservation_params
    params.require(:reservation).permit(:start_at, :type_name)
  end
end
