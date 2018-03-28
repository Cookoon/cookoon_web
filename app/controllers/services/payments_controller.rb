class Services::PaymentsController < ApplicationController
  before_action :set_service
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def create
    # payment_service = StripePaymentService.new(
    #   {
    #     user: @reservation.user,
    #     source: params[:payment][:source],
    #     reservation: @reservation,
    #     service: @service
    #   },
    #   discount: params[:payment][:use_discount]
    # )
    payment = Service::Payment.new(@service, service_params)
    if payment.proceed
      redirect_to cookoons_path, flash: { service_payment_succeed: true }
    else
      @user_cards = current_user.crredit_cardds
      flash.now.alert = payment_service.displayable_errors
      render :new
    end
  end

  def discount
    @base_price = @service.price
    @user_discount = @reservation.user.discount_balance
    @computed_prices = compute_discount(@base_price, @user_discount)
    render 'payments/discount'
  end

  private

  def compute_discount(base_price, user_discount)
    {
      discounted_price: [Money.new(0, 'EUR'), (base_price - user_discount)].max,
      available_discount: [Money.new(0, 'EUR'), (user_discount - base_price)].max
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
