class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :general_conditions
  before_action :disable_turbolinks_cache, only: :home

  def home
    @reservation = Reservation.new.decorate
    @end_date_available = ((Date.today + Availability::SETTABLE_WEEKS_AHEAD.weeks).beginning_of_week) - 1.days
    @dates_with_no_cookoon_available_for_current_user = Array.new
    (Date.today..@end_date_available).to_a.each do |date|
      @dates_with_no_cookoon_available_for_current_user << date.strftime("%Y-%m-%d") if Cookoon.available_for(current_user).available_in_day(date).blank?
    end
  end

  def support; end

  def general_conditions; end

end
