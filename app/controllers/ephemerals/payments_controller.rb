class Ephemerals::PaymentsController < ApplicationController
  before_action :set_ephemeral
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    @reservation = Reservation.new(reservation_params)
    payment = Reservation::Payment.new(@reservation, payment_params)
    if payment.proceed
      redirect_to cookoons_path, flash: { service_payment_succeed: true }
    else
      @credit_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render 'ephemerals/show'
    end
  end

  def amounts
    @amounts = build_amounts.merge(payment_params.to_h.symbolize_keys)
    respond_to :json
  end

  private

  def build_amounts
    @reservation = Reservation.new(reservation_params)
    discount_amount = @reservation.payment(payment_params).discountable_discount_amount
    {
      discount_amount: discount_amount,
      charge_amount: @reservation.payment(payment_params).discountable_charge_amount,
      user_discount_balance: @reservation.user.discount_balance - discount_amount
    }
  end

  def set_ephemeral
    @ephemeral = Ephemeral.find(params[:ephemeral_id])
  end

  def payment_params
    params.require(:payment).permit(:discount)
  end

  def reservation_params
    {
      user: current_user,
      cookoon: @ephemeral.cookoon,
      start_at: @ephemeral.start_at,
      duration: @ephemeral.duration,
      people_count: @ephemeral.people_count,
    }
  end
end
