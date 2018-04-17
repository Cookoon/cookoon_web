class Services::PaymentsController < ApplicationController
  before_action :set_service
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    payment = Service::Payment.new(@service, service_params)
    if payment.proceed
      redirect_to cookoons_path, flash: { service_payment_succeed: true }
    else
      @credit_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render :new
    end
  end

  def discount
    @amounts = build_amounts
    render 'payments/discount'
  end

  private

  def build_amounts
    payment_amount = @service.payment_amount
    user_discount_balance = @service.user.discount_balance
    charge_amount = @service.payment(discount: true).discountable_charge_amount
    discount_amount = @service.payment(discount: true).discountable_discount_amount

    {
      payment: payment_amount,
      user_discount_balance: user_discount_balance,
      charge: charge_amount,
      remaining_user_discount_balance: (user_discount_balance - discount_amount)
    }
  end

  def set_service
    @service = Service.find(params[:service_id])
    @reservation = @service.reservation
    # authorize @service
  end

  def service_params
    params.require(:payment)
  end
end
