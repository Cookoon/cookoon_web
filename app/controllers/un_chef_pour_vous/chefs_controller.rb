class UnChefPourVous::ChefsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_reservation, only: %i[index show]
  before_action :find_chef, only: %i[show]

  def index
    chefs = Chef.amex
    @chefs_available = chefs.available_in_day(@reservation.start_at).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
    @chefs_unavailable = chefs.unavailable_in_day(@reservation.start_at).includes(:main_photo_files, :chef_perks, chef_perks: :chef_perk_specification)
  end

  def show
    @menus = @chef.menus.amex
  end

  private

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def find_chef
    @chef = Chef.find(params[:id])
  end

end
