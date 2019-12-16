class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome
  before_action :disable_turbolinks_cache, only: :home

  def home
    @reservation = Reservation.new.decorate
  end

  def support; end

  def general_conditions; end

end
