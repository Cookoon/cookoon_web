class Host::UsersController < ApplicationController
  def dashboard
    @user = current_user
    authorize [:host, @user]
    @pending_reservations_count = @user.reservations_requests.paid.count
    @cookoons = @user.cookoons
  end
end
