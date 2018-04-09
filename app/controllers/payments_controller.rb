class PaymentsController < ApplicationController
  before_action :set_reservation

  def new
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

  def discount
    @amounts = build_amounts
  end

  private

  def build_amounts
    payment_amount = @reservation.payment_amount
    user_discount_balance = @reservation.user.discount_balance
    charge_amount = @reservation.payment(discount: true).computed_charge_amount
    discount_amount = @reservation.payment(discount: true).computed_discount_amount

    {
      payment: payment_amount,
      user_discount_balance: user_discount_balance,
      charge: charge_amount,
      remaining_user_discount_balance: (user_discount_balance - discount_amount)
    }
  end

  def set_reservation
    @reservation = Reservation.where(status: :pending).find(params[:reservation_id])
    authorize @reservation
  end

  def payment_params
    params.require(:payment)
  end

  def handle_redirection
    if @reservation.catering
      redirect_to cookoons_path, flash: { catering_requested: true }
    else
      redirect_to cookoons_path, flash: { payment_succeed: true }
    end
  end
end
