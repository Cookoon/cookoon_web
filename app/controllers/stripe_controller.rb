class StripeController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_after_action :verify_authorized
  protect_from_forgery except: :webhook

  def webhook
    # byebug
    # Process webhook data in `params`
    render json: { message: "OK" }, status: :ok
  end
end
