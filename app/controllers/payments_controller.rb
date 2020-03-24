class PaymentsController < ApplicationController
  before_action :find_reservation
  before_action :find_cookoon, only: %i[amounts]

  def secret
    payment = Reservation::Payment.new(@reservation.object)
    if payment.create_or_retrieve_and_update
      @intent_secret_json = {client_secret: payment.return_stripe_client_secret}.to_json
    else
      flash.alert = payment.displayable_errors
      redirect_to new_reservation_payment_path(payment.payable)
    end
  end

  def new
    @url_intent_secret = "/reservations/#{@reservation.id}/payments/secret.json"
    @credit_cards = current_user.credit_cards
    @cookoon = @reservation.cookoon.decorate

    @payment_method_to_display_first = current_user.find_default_stripe_payment_method || @credit_cards.first
  end

  def create
    payment = Reservation::Payment.new(@reservation.object)
    if payment.charge
      @reservation.notify_users_after_payment
      redirect_to new_reservation_message_path(@reservation)
    else
      flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
      redirect_to home_path
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
end
