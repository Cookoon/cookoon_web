module Pro
  class PagesController < ApplicationController
    def home
      authorize([:pro, current_user], :pro?)
      @quote = Quote.new
      @cookoons = Cookoon.random.limit(3).decorate
    end
  end
end
