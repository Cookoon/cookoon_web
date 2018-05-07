class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[welcome setcookies]
  before_action :disable_turbolinks_cache, only: :home

  def welcome; end

  def home
    @search = Search.new
  end

  def support; end

  # TODO: FC 04may18 clean all gecolocation code
  def setcookies
    lat_lng = "#{params[:lat]}|#{params[:lng]}"
    cookies[:lat_lng] ||= { value: lat_lng, expires: 5.hours.from_now }
  end
end
