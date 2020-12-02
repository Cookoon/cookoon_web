class ChefsController < ApplicationController

  before_action :find_reservation, only: %i[index show]
  before_action :find_chef, only: %i[show]

  def index
    # TO DO display only chefs that do not have another reservation
    # # policy_scope displays chef that only have active menus thanks to scope.has_active_menus in chef policy
    chefs = policy_scope(Chef).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
    chefs_with_active_seated_menus = chefs.has_active_seated_menus
    chefs_with_active_standing_menus = chefs.has_active_standing_menus
    if @reservation.seated?
      @chefs_available = chefs_with_active_seated_menus.without_engaged_reservations_in_day(@reservation.start_at)
      @chefs_unavailable = chefs_with_active_seated_menus.with_engaged_reservations_in_day(@reservation.start_at)
    elsif @reservation.standing?
      @chefs_available = chefs_with_active_seated_menus.without_engaged_reservations_in_day(@reservation.start_at)
      @chefs_unavailable = chefs_with_active_standing_menus.with_engaged_reservations_in_day(@reservation.start_at)
    else
      @chefs = policy_scope(Chef).none
    end
  end

  def show
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
    authorize(@reservation, :update?)
  end

  def find_chef
    @chef = Chef.includes(menus: :dishes).find(params[:id])
    authorize @chef
  end

end
