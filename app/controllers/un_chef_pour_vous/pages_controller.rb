class UnChefPourVous::PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :set_start_date_available, only: :home
  before_action :set_end_date_available, only: :home
  before_action :set_dates_unavailable, only: :home

  def home
    @reservation = Reservation.new(category: 'amex', people_count: 2).decorate
  end

  private

  def set_start_date_available
    if Date.today < Date.new(2021, 2, 12)
      @start_date_available = Date.new(2021, 2, 15)
    else
      @start_date_available = Date.today + 3.days
    end
  end

  def set_end_date_available
    @end_date_available = Date.new(2021, 6, 30)
  end

  def set_dates_unavailable
    @dates_unavailable = Array.new
    # @dates_unavailable = Array.new
    # (Date.today..@end_date_available).to_a.each do |date|
    #   if Cookoon.amex.approved.displayable_on_index.available_in_day(date).blank? || Chef.amex.without_engaged_reservations_in_day(date).blank?
    #     @dates_unavailable << date.strftime("%Y-%m-%d")
    #   end
    # end
  end
end
