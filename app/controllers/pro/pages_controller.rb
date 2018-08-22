module Pro
  class PagesController < ApplicationController
    def home
      @quote = Quote.new
      @cookoons = Cookoon.random.limit(3).decorate
      @durations = build_duration
    end

    private

    def build_duration
      [
        {data: 2, display: 'une réunion (2 heures)'},
        {data: 4, display: 'un comité (4 heures)'},
        {data: 5, display: 'demi-journée (5 heures)'},
        {data: 10, display: 'journée complète (10 heures)'}
      ]
    end
  end
end
