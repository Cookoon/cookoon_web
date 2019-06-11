class PaymentsController < ApplicationController
  before_action :find_reservation
  before_action :find_cookoon, only: %i[amounts]

  def new
    @service_categories = build_service_categories
    @credit_cards = current_user.credit_cards
    @cookoon = @reservation.cookoon.decorate
  end

  def create
    payment = Reservation::Payment.new(@reservation)
    if payment.proceed
      @reservation.notify_users_after_payment
      redirect_to new_reservation_message_path(@reservation)
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
      user_discount_balance: @reservation.user.discount_balance - discount_amount,
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

  # TODO: CP 2may2018 Try to refactor this
  def build_service_categories
    reservation_service_categories = @reservation.services.pluck(:category)
    Service.categories.keys.reverse.map do |category|
      if reservation_service_categories.exclude? category
        { url: reservation_services_path(@reservation), method: 'post', selected: 'false' }
      else
        reservation_service = @reservation.services.find_by(category: category)
        { url: service_path(reservation_service), method: 'delete', selected: 'true' }
      end.merge(display_options_for(category))
    end
  end

  def display_options_for(category)
    case category
    when 'corporate'
      { icon_name: 'pro', display_name: "Carnets,<br />eau, etc." }
    when 'chef'
      { icon_name: 'chef', display_name: 'Chef<br />privé' }
    when 'catering'
      { icon_name: 'food', display_name: 'Plateaux<br />repas' }
    when 'special'
      { icon_name: 'concierge', display_name: 'Un besoin<br />particulier ?' }
    end.merge(category: category)
  end
end
