class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: [:support]
  layout "naked", except: [:support, :cgu]

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

  def support
  end

  def cgu
  end

  def setcookies
    lat_lng = "#{params[:lat]}|#{params[:lng]}"
    cookies[:lat_lng] ||= { value: lat_lng, expires: 5.hour.from_now }
  end
end
