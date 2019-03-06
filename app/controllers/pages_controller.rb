class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :welcome
  before_action :disable_turbolinks_cache, only: :home

  def welcome; end

  def home
    @search = CookoonSearch.new
    @highlighted_cookoon = Cookoon.approved.over_price(Cookoon::HIGHLIGHT_PRICE_CENTS).includes(:photo_files).sample
  end

  def support; end

  def desktop_only; end
end
