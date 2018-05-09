class Ephemerals::PaymentsController < ApplicationController
  before_action :set_ephemeral
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    # TODO CP 9may2018 we should check this part and maybe improve it
    if @ephemeral.unavailable?
      return redirect_to @ephemeral, flash: { alert: "Vous avez été devancé, l'offre n'est dejà plus disponible !" }
    end

    @reservation = Reservation.new(reservation_params)
    @reservation.services.build(payment_tied_to_reservation: true, price_cents: @ephemeral.service_price_cents)
    @reservation.save
    payment = Reservation::Payment.new(@reservation, payment_params)
    if payment.proceed
      @reservation.accepted!
      @ephemeral.unavailable!
      redirect_to root_path, flash: { service_payment_succeed: true }
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
      people_count: @ephemeral.people_count
    }
  end
end
