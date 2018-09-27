module Pro
  class PagesController < ApplicationController
    def home
      @quote = Quote.new
      @cookoons = Cookoon.displayable_on_index.random.limit(4).decorate
    end
  end
end
