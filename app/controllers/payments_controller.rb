class PaymentsController < ApplicationController
  before_action :set_reservation

  def new
    @service_categories = Service.categories.keys.reverse
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
end
