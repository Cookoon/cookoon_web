module Pro
  class QuotesController < ApplicationController
    def index
      @quotes = policy_scope(Pro::Quote)
                .where.not(status: :initial)
                .includes(:reservations)
                .where.not(pro_reservations: { status: Pro::Reservation.statuses[:draft] })
                .order(:created_at)
                .order('pro_reservations.created_at')
                .decorate
    end

    def create
      @quote = Quote.new(quote_params.merge(user: current_user, company: current_user.company))
      authorize @quote

      if @quote.save
        redirect_to pro_quote_cookoons_path(@quote)
      else
        render :new
      end
    end

    def update
      @quote = Quote.find(params[:id])
      authorize @quote

      @quote.update(quote_params.slice(:comment).merge(status: :requested))

      redirect_to pro_quote_request_confirmation_path(@quote)
    end

    def request_confirmation
      quote = Quote.find(params[:quote_id])
      authorize quote, :update?
    end

    private

    def quote_params
      params.require(:pro_quote).permit(:start_at, :duration, :people_count, :comment)
    end
  end
end
