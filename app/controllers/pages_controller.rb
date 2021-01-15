class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :general_conditions
  before_action :disable_turbolinks_cache, only: :home
  before_action :set_start_date_available, only: :home
  before_action :set_end_date_available, only: :home
  before_action :set_dates_unavailable, only: :home

  def home
    # @reservation = Reservation.new(user: current_user).decorate
    @reservation = Reservation.new(user: current_user).decorate
  end

  def support; end

  def general_conditions; end

  private

  def set_start_date_available
    if Date.today < Date.new(2021, 2, 12)
      @start_date_available = Date.new(2021, 2, 15)
    else
      @start_date_available = Date.today + 3.days
    end
  end

  def set_end_date_available
    # @end_date_available = ((Date.today + Availability::SETTABLE_WEEKS_AHEAD.weeks).beginning_of_week) - 1.days
    @end_date_available = Date.today + 1.years
  end

  def set_dates_unavailable
    @dates_unavailable = Array.new
    # @dates_unavailable = Array.new
    # (Date.today..@end_date_available).to_a.each do |date|
    #   if Cookoon.available_for(current_user).available_in_day(date).blank? || Chef.without_engaged_reservations_in_day(date).blank?
    #     @dates_unavailable << date.strftime("%Y-%m-%d")
    #   end
    # end
  end

end
