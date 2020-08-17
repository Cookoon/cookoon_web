class ChefsController < ApplicationController

  before_action :find_reservation, only: %i[index show]
  before_action :find_chef, only: %i[show]

  def index
    # filtering_params = {
    #   accomodates_for: @reservation.people_count,
    #   available_in: (@reservation.start_at..@reservation.end_at),
    #   available_for: current_user
    # }

    # TO DO display only chefs that do not have another reservation
    # policy_scope displays chef that only have active menus thanks to scope.has_active_menus in chef policy
    @chefs = policy_scope(Chef).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
  end

  def show
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def find_chef
    @chef = Chef.includes(menus: :dishes).find(params[:id])
    authorize @chef
  end

end
