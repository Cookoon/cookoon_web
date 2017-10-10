class Host::InventoriesController < ApplicationController
  before_action :find_reservation, only: [:new, :create]
  before_action :build_inventory, only: [:create]
  before_action :find_inventory, only: [:edit, :update]

  def new
    @reservation.inventory ? redirect_with_error : build_inventory
  end

  def create
    full_params = checkin_inventory_params.merge(checkin_at: DateTime.now)
    @inventory = @reservation.build_inventory(full_params)
    if @inventory.save && @reservation.ongoing!
      flash[:notice] = 'La reservation vient de démarrer'
      redirect_to host_reservations_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    reservation = @inventory.reservation
    full_params = checkout_inventory_params.merge({checkout_at: DateTime.now, status: :checked_out})
    if @inventory.update(full_params) && reservation.passed!
      flash[:noice] = "La réservation est maintenant terminée"
      redirect_to host_reservations_path
    else
      render :edit
    end
  end

  private

  def redirect_with_error
    flash[:alert] = "La réservation a déja commencé"
    redirect_to host_reservations_path
  end

  def build_inventory
    @inventory = @reservation.build_inventory
    authorize [:host, @inventory]
  end

  def find_inventory
    @inventory = Inventory.find(params[:id])
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def checkin_inventory_params
    params.require(:inventory).permit(checkin_photos: [])
  end

  def checkout_inventory_params
    params.require(:inventory).permit(checkout_photos: [])
  end
end
