class Services::PaymentsController < ApplicationController
  before_action :set_service
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    payment = Service::Payment.new(@service)
    if payment.proceed
      redirect_to reservations_path, flash: { service_payment_succeed: true }
    else
      @credit_cards = current_user.credit_cards
      flash.now.alert = payment.displayable_errors
      render :new
    end
  end

  def amounts
    @amounts = build_amounts
    respond_to :json
  end

  private

  def build_amounts
    {
      charge_amount: @service.payment.discountable_charge_amount,
    }
  end

  def set_service
    @service = Service.find(params[:service_id])
    @reservation = @service.reservation
    # authorize @service
  end
end
