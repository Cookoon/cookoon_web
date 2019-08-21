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
      flash.alert = payment.displayable_errors
      render 'services/show'
    end
  end

  private

  def set_service
    @service = Service.find(params[:service_id])
    @reservation = @service.reservation
  end
end
