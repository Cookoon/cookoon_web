class ChefsController < ApplicationController

  before_action :find_reservation, only: %i[index show]
  before_action :find_chef, only: %i[show]

  def index
    # TO DO display only chefs that do not have another reservation
    # # policy_scope displays chef that only have active menus thanks to scope.has_active_menus in chef policy
    # @chefs = policy_scope(Chef).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
    if @reservation.seated?
      @chefs = policy_scope(Chef).has_active_seated_menus.without_engaged_reservations_in_day(@reservation.start_at).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
    elsif @reservation.standing?
      @chefs = policy_scope(Chef).has_active_standing_menus.without_engaged_reservations_in_day(@reservation.start_at).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
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
