class PaymentsController < ApplicationController
  before_action :find_reservation
  before_action :find_cookoon, only: %i[amounts]

  # def secret_cookoon_butler
  #   # payment = Reservation::Payment.new(@reservation.object)
  #   # if payment.create_or_retrieve_and_update
  #   payment_cookoon = Reservation::Payment.new(@reservation.object, options = { capture_method: 'manual', charge_amount_cents: @reservation.object.cookoon_butler_with_tax_cents})
  #   proceed_payment(payment_cookoon, :stripe_charge_id)
  # end

  # def secret_services
  #   payment_services = Reservation::Payment.new(@reservation.object, options = { capture_method: 'automatic', charge_amount_cents: @reservation.object.services_with_tax_cents})
  #   proceed_payment(payment_services, :stripe_services_id)
  # end

  def secret_cookoon_butler
    secret('manual', @reservation.object.cookoon_butler_with_tax_cents, :stripe_charge_id)
  end

  def secret_menu
    secret('automatic', @reservation.object.menu_with_tax_cents, :stripe_menu_id)
  end

  def secret_services
    secret('automatic', @reservation.object.services_with_tax_cents, :stripe_services_id)
  end

  def new
    if @reservation.cookoon.blank?
      flash.alert = "Vous devez choisir un décor"
      redirect_to reservation_cookoons_path(@reservation)
    elsif @reservation.menu_status == "initial"
      flash.alert = "Vous devez choisir un menu ou indiquer si vous souhaitez cuisiner vous-même"
      redirect_to reservation_chefs_path(@reservation)
    else
      if policy(@reservation).secret_cookoon_butler?
        @url_intent_secret_cookoon_butler = "/reservations/#{@reservation.id}/payments/secret_cookoon_butler.json"
      elsif policy(@reservation).secret_menu?
        @url_intent_secret_menu = "/reservations/#{@reservation.id}/payments/secret_menu.json"
      elsif policy(@reservation).secret_services?
        @url_intent_secret_services = "/reservations/#{@reservation.id}/payments/secret_services.json"
      end

      @credit_cards = current_user.credit_cards

      @payment_method_to_display_first = current_user.find_default_stripe_payment_method || @credit_cards.first

      @total = @reservation.total_with_tax
      @total = @total - @reservation.cookoon_butler_with_tax + @reservation.stripe_payment_intent_amount_cookoon_butler if @reservation.stripe_charge_id.present?
      @total = @total - @reservation.menu_with_tax + @reservation.stripe_payment_intent_amount_menu if @reservation.stripe_menu_id.present?
      @total = @total - @reservation.services_with_tax + @reservation.stripe_payment_intent_amount_services if @reservation.stripe_services_id.present?
    end
  end

  def create
    # TO DO ALICE : notify user after payment by mail
    # @reservation.notify_users_after_payment

    # payment = Reservation::Payment.new(@reservation.object)
    payment = @reservation.payment
    if @reservation.needs_cookoon_butler_payment?
      if payment.charge
        flash.notice = "Votre paiement a bien été effectué."
        @reservation.notify_users_after_cookoon_butler_payment
        redirect_to new_reservation_message_path(@reservation)
      else
        flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
        redirect_to home_path
      end
    elsif @reservation.needs_menu_payment?
      if payment.capture_menu_payment
        @reservation.notify_users_after_menu_payment
        flash.notice = "Votre paiement a bien été effectué."
        redirect_to home_path
      else
        flash.alert = "Une erreur est survenue, néanmoins votre demande de paiement est bien effective. Veuillez contacter notre service d'aide"
        redirect_to home_path
      end
    elsif @reservation.needs_services_payment?
      if payment.capture_services_payment
        flash.notice = "Votre paiement a bien été effectué."
        @reservation.notify_users_after_services_payment
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
    authorize(@reservation, :update?)
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
    @reservation.select_cookoon(@cookoon)
  end

  def secret(capture_method_value, charge_amount_cents_value, stripe_charge_id_value)
    payment = Reservation::Payment.new(@reservation.object, options = { capture_method: capture_method_value, charge_amount_cents: charge_amount_cents_value })
    proceed_payment(payment, stripe_charge_id_value)
  end

  def proceed_payment(payment, stripe_intent)
    if payment.create_or_retrieve_and_update(stripe_intent)
      # @stripe_intent_secret_json = {client_secret: payment.return_stripe_client_secret}.to_json
      @stripe_intent = payment.return_stripe_intent
    else
      flash.alert = payment.displayable_errors
      redirect_to new_reservation_payment_path(payment.payable)
    end
  end
end
