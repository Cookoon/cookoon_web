class PaymentsController < ApplicationController
  before_action :set_reservation

  def new
    payment_service = StripePaymentService.new(
      user: current_user,
      reservation: @reservation
    )
    @user_cards = payment_service.user_sources.try(:data)
  end

  def create
    payment_service = StripePaymentService.new(
      {
        user: @reservation.user,
        source: params[:payment][:source],
        reservation: @reservation
      },
      discount: params[:payment][:use_discount]
    )
    @user_cards = payment_service.user_sources.try(:data)
    if payment_service.handle_payment_and_update_reservation
      ReservationMailer.new_request(@reservation).deliver_later
      ReservationMailer.pending_request(@reservation).deliver_later
      redirect_to cookoons_path, flash: { payment_succeed: true }
    else
      flash.now.alert = payment_service.displayable_errors
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
end
