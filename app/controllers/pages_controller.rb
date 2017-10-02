class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout "naked"

  def home
  end

  def about
  end

  def about_rent
  end

  def about_hosting
  end

  def about_warranties
  end

  def setcookies
    lat_lng = "#{params[:lat]}|#{params[:lng]}"
    cookies[:lat_lng] ||= { value: lat_lng, expires: 5.hour.from_now }
  end
end
