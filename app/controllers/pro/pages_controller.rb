module Pro
  class PagesController < ApplicationController
    def home
      @quote = Quote.new
      @cookoons = Cookoon.random.limit(3).decorate
    end
  end
end
