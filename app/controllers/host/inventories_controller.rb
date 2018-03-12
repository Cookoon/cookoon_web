class Host::InventoriesController < ApplicationController
  before_action :find_reservation, only: [:new, :create]
  before_action :build_inventory, only: [:create]
  before_action :find_inventory, only: [:edit, :update]

  def new
    @reservation.inventory ? redirect_with_error : build_inventory
  end

  def create
    @inventory.attributes = inventory_params.merge(checkin_at: Time.zone.now)
    if @inventory.save && @reservation.ongoing!
      payment_service = StripePaymentService.new(user: @reservation.cookoon_owner, reservation: @reservation)
      # Pas de test ici, il faut monitorer sur les premieres locations
      # Ajouter une transaction ? Ou poster sur Slack pour le declencher a la main.
      payment_service.pay_host
      flash[:notice] = 'La reservation vient de démarrer'
      redirect_to host_reservations_path
    else
      render :new
    end
  end

  def edit; end

  def update
    reservation = @inventory.reservation
    full_params = inventory_params.merge(checkout_at: Time.zone.now, status: :checked_out)
    if @inventory.update(full_params) && reservation.passed!
      ReservationMailer.ending_survey_to_tenant(reservation).deliver_later
      ReservationMailer.ending_survey_to_host(reservation).deliver_later
      flash[:notice] = 'La réservation est maintenant terminée'
      redirect_to host_reservations_path
    else
      render :edit
    end
  end

  private

  def redirect_with_error
    flash[:alert] = 'La réservation a déja commencé'
    redirect_to host_reservations_path
  end

  def build_inventory
    @inventory = @reservation.build_inventory
    authorize [:host, @inventory]
  end

  def find_inventory
    @inventory = Inventory.find(params[:id])
    authorize [:host, @inventory]
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id])
    authorize [:host, @reservation]
  end

  def inventory_params
    params.require(:inventory).permit(:remark, checkin_photos: [], checkout_photos: [])
  end
end
