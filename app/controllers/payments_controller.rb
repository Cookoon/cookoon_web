class PaymentsController < ApplicationController
  before_action :set_reservation

  def new
    @service_categories = build_service_categories
    @credit_cards = current_user.credit_cards
  end

  def create
    payment = Reservation::Payment.new(@reservation, payment_params)
    if payment.proceed
      @reservation.notify_users_after_payment
      handle_redirection
    else
      @credit_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render :new
    end
  end

  def amounts
    @amounts = build_amounts.merge(payment_params.to_h.symbolize_keys)
    respond_to :json
  end

  private

  def build_amounts
    discount_amount = @reservation.payment(payment_params).discountable_discount_amount

    {
      services_price: @reservation.services_price,
      discount_amount: discount_amount,
      charge_amount: @reservation.payment(payment_params).discountable_charge_amount,
      user_discount_balance: @reservation.user.discount_balance - discount_amount
    }
  end

  def set_reservation
    @reservation = Reservation.where(status: :pending).find(params[:reservation_id])
    authorize @reservation
  end

  def payment_params
    params.require(:payment).permit(:discount)
  end

  def handle_redirection
    if @reservation.catering
      redirect_to reservations_path, flash: { catering_requested: true }
    else
      redirect_to reservations_path, flash: { payment_succeed: true }
    end
  end

  # TODO: CP 2may2018 Try to refactor this
  def build_service_categories
    reservation_service_categories = @reservation.services.pluck(:category)
    Service.categories.keys.reverse.map do |category|
      if reservation_service_categories.exclude? category
        { url: reservation_services_path(@reservation), method: 'post', selected: 'false' }
      else
        reservation_service = @reservation.services.find_by(category: category)
        { url: service_path(reservation_service), method: 'delete', selected: 'true' }
      end.merge(category: category)
    end
  end
end
