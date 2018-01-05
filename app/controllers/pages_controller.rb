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

  def apple_app_site_association
    association_json = File.read(Rails.public_path + "apple-app-site-association")
    render json: association_json, content_type: "application/json"
  end

  def android_assetlinks
    association_json = File.read(Rails.public_path + "android_assetlinks.json")
    render json: association_json, content_type: "application/json"
  end
end
