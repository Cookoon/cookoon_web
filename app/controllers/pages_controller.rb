class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: :support
  layout 'naked', except: :support

  def home; end

  def support; end

  def setcookies
    lat_lng = "#{params[:lat]}|#{params[:lng]}"
    cookies[:lat_lng] ||= { value: lat_lng, expires: 5.hours.from_now }
  end

  def apple_app_site_association
    association_json = File.read(Rails.public_path + 'apple-app-site-association')
    render json: association_json, content_type: 'application/json'
  end

  def android_assetlinks
    association_json = File.read(Rails.public_path + 'android_assetlinks.json')
    render json: association_json, content_type: 'application/json'
  end
end
