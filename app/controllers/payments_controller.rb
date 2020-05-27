class PaymentsController < ApplicationController
  before_action :find_reservation
  before_action :find_cookoon, only: %i[amounts]

  def secret
    # payment = Reservation::Payment.new(@reservation.object)
    # if payment.create_or_retrieve_and_update
    payment_cookoon = Reservation::Payment.new(@reservation.object, options = { capture_method: 'manual', charge_amount_cents: @reservation.object.cookoon_price_cents})
    proceed_payment(payment_cookoon, :stripe_charge_id)
  end

  def secret_services
    payment_services = Reservation::Payment.new(@reservation.object, options = { capture_method: 'automatic', charge_amount_cents: @reservation.object.services_with_tax_cents})
    proceed_payment(payment_services, :stripe_services_id)
  end

  def new
    @url_intent_secret = "/reservations/#{@reservation.id}/payments/secret.json"
    @url_intent_secret_services = "/reservations/#{@reservation.id}/payments/secret_services.json"
    @credit_cards = current_user.credit_cards
    @cookoon = @reservation.cookoon.decorate

    @payment_method_to_display_first = current_user.find_default_stripe_payment_method || @credit_cards.first
  end

  def create
    # payment = Reservation::Payment.new(@reservation.object)
    payment = @reservation.payment
    if @reservation.services_selected? || @reservation.cookoon_selected?
      if payment.charge
        @reservation.notify_users_after_payment
        redirect_to new_reservation_message_path(@reservation)
      else
        flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
        redirect_to home_path
      end
    elsif @reservation.accepted?
      if payment.pay_services
        # TO DO ALICE : notify user after payment by mail
        # @reservation.notify_users_after_payment
        flash.notice = "Votre paiement a bien été effectué"
        redirect_to home_path
      else
        flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
        redirect_to home_path
      end
    end

    # if payment.proceed
    #   @reservation.notify_users_after_payment
    #   redirect_to new_reservation_message_path(@reservation)
    # else
    #   @credit_cards = current_user.credit_cards
    #   flash.now.alert = payment.displayable_errors
    #   render :new
    # end
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

  def proceed_payment(payment, stripe_intent)
    if payment.create_or_retrieve_and_update(stripe_intent)
      @stripe_intent_secret_json = {client_secret: payment.return_stripe_client_secret}.to_json
    else
      flash.alert = payment.displayable_errors
      redirect_to new_reservation_payment_path(payment.payable)
    end
  end
end
