class PaymentsController < ApplicationController
  before_action :find_reservation
  before_action :find_cookoon, only: %i[amounts]

  def new
    @service_categories = build_service_categories
    @credit_cards = current_user.credit_cards
    @cookoon = @reservation.cookoon.decorate
  end

  def create
    payment = Reservation::Payment.new(@reservation.object)
    if payment.proceed
      @reservation.notify_users_after_payment
      redirect_to new_reservation_message_path(@reservation)
    else
      @credit_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render :new
    end
  end

  def amounts
    @amounts = build_amounts
    respond_to :json
  end

  private

  def build_amounts
    @reservation.assign_prices
    {
      charge_amount: @reservation.total_full_price,
      services_count: @reservation.services.count
    }
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
    authorize @reservation
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
    @reservation.select_cookoon(@cookoon)
  end
end
