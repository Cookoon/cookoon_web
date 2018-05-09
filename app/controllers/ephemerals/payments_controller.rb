class Ephemerals::PaymentsController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def new
    
  end

  def create
    payment = Service::Payment.new(@service, payment_params)
    if payment.proceed
      redirect_to cookoons_path, flash: { service_payment_succeed: true }
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
    discount_amount = @service.payment(payment_params).discountable_discount_amount

    {
      discount_amount: discount_amount,
      charge_amount: @service.payment(payment_params).discountable_charge_amount,
      user_discount_balance: @service.user.discount_balance - discount_amount
    }
  end

  def set_service
    @service = Service.find(params[:service_id])
    @reservation = @service.reservation
    # authorize @service
  end

  def payment_params
    params.require(:payment).permit(:discount)
  end
end
