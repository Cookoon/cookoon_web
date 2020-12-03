class UnChefPourVous::ReservationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create select_cookoon select_menu]
  before_action :find_reservation, only: %i[select_cookoon select_menu]
  before_action :find_cookoon, only: %i[select_cookoon]

  def create
    @reservation = Reservation.new(reservation_params.merge(category: 'amex', people_count: 2))
    if @reservation.save
      redirect_to un_chef_pour_vous_reservation_cookoons_path(@reservation)
    else
      flash.alert = "Votre réservation n'est pas valide, vous devez remplir tous les champs."
      redirect_to un_chef_pour_vous_root_path
    end
  end

  def select_cookoon
    if @reservation.pending?
      if @reservation.select_cookoon!(@cookoon)
        redirect_to un_chef_pour_vous_reservation_cookoon_path(@reservation, @cookoon)
      else
        redirect_to un_chef_pour_vous_reservation_cookoons_path(@reservation), alert: "Une erreur s'est produite, veuillez essayer à nouveau"
      end
    else
      redirect_to un_chef_pour_vous_reservation_cookoon_path(@reservation, @cookoon)
    end
  end

  def select_menu
    @reservation.select_menu!(Menu.find(params[:menu_id]))
    @reservation.update(menu_status: "selected")
    redirect_to un_chef_pour_vous_reservation_chefs_path(@reservation), flash: { check_of_chef_availability_needed: true }
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_at, :type_name)
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end
end
