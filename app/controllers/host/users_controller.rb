class Host::UsersController < ApplicationController
  def dashboard
    @user = current_user
    authorize [:host, @user]
    @pending_reservations_count = @user.reservation_requests.paid.count
    @cookoons = @user.cookoons.includes(:photo_files)
  end
end
