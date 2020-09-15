class Host::UsersController < ApplicationController
  def dashboard
    @user = current_user
    authorize [:host, @user]
    @pending_reservations_count = @user.reservation_requests.charged.count
    @cookoons = @user.cookoons.includes(:main_photo_files).decorate
  end
end
