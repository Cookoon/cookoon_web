module Pro
  class QuotesController < ApplicationController
    def index; end

    def create
      @quote = Quote.new(quote_params.merge(user: current_user, company: current_user.company))
      authorize @quote

      if @quote.save
        redirect_to pro_root_path
      else
        render :new
      end
    end

    def update; end

    private

    def quote_params
      params.require(:pro_quote).permit(:start_at, :duration, :people_count)
    end
  end
end
