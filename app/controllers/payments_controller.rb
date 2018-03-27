class PaymentsController < ApplicationController
  before_action :set_reservation

  def new
    @user_cards = current_user.credit_cards
  end

  def create
    payment = Reservation::Payment.new(@reservation, payment_params)
    if payment.proceed
      @reservation.notify_users_after_payment
      handle_redirection
    else
      @user_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render :new
    end
  end

  def discount
    @base_price = @reservation.price_with_tenant_fee
    @user_discount = @reservation.user.discount_balance
    @computed_prices = compute_discount(@base_price, @user_discount)
  end

  private

  def compute_discount(base_price, user_discount)
    {
      discounted_price: [Money.new(0, 'EUR'), (base_price - user_discount)].max,
      available_discount: [Money.new(0, 'EUR'), (user_discount - base_price)].max
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
