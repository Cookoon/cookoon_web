class Ephemerals::PaymentsController < ApplicationController
  before_action :find_ephemeral
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    if @ephemeral.unavailable?
      return redirect_to @ephemeral, flash: { alert: "Vous avez été devancé, l'offre n'est dejà plus disponible !" }
    end

    @reservation = Reservation.new(reservation_params)
    payment = Reservation::Payment.new(@reservation, payment_params)
    if @reservation.save && payment.proceed
      @reservation.accepted!
      @ephemeral.unavailable!
      @reservation.notify_users_after_confirmation
      redirect_to reservations_path, flash: { ephemeral_payment_succeed: true }
    else
      flash.alert = (@reservation.errors.full_messages + payment.errors).join(', ')
      redirect_to @ephemeral
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
      charge_amount: @reservation.payment(payment_params).discountable_charge_amount,
      user_discount_balance: @reservation.user.discount_balance - discount_amount
    }
  end

  def find_ephemeral
    @ephemeral = Ephemeral.find(params[:ephemeral_id])
  end

  def payment_params
    params.require(:payment).permit(:source, :discount).merge(capture: true)
  end

  def reservation_params
    @ephemeral.attributes.with_indifferent_access.slice(:cookoon_id, :start_at, :duration, :people_count)
              .merge(
                user: current_user,
                services_attributes: [{
                  payment_tied_to_reservation: true,
                  price_cents: @ephemeral.service_price_cents
                }]
              )
  end
end
