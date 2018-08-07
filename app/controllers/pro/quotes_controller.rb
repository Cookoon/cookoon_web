module Pro
  class QuotesController < ApplicationController
    def index
      @quotes = policy_scope(Pro::Quote.request)
                .includes(:reservations)
                .where(pro_reservations: { status: 1 })
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

      @quote.update(quote_params.slice(:comment).merge(status: :request))

      flash.notice = 'Votre demande de devis a bien été transmise, nous revenons vers vous rapidement'
      redirect_to pro_root_path
    end

    private

    def quote_params
      params.require(:pro_quote).permit(:start_at, :duration, :people_count, :comment)
    end
  end
end
