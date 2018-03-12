class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home setcookies]
  layout 'naked', only: %i[home setcookies]

  def home; end

  def support; end

  def setcookies
    lat_lng = "#{params[:lat]}|#{params[:lng]}"
    cookies[:lat_lng] ||= { value: lat_lng, expires: 5.hours.from_now }
  end
end
