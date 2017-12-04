class Host::InventoriesController < ApplicationController
  before_action :find_reservation, only: [:new, :create]
  before_action :build_inventory, only: [:create]
  before_action :find_inventory, only: [:edit, :update]

  def new
    @reservation.inventory ? redirect_with_error : build_inventory
  end

  def create
    @inventory = @reservation.build_inventory(checkin_at: DateTime.now)
    if @inventory.save && @reservation.ongoing!
      paiement_service = StripePaiementService.new(user: @reservation.cookoon_owner, reservation: @reservation)
      # Pas de test ici, il faut monitorer sur les premieres locations
      # Ajouter une transaction ? Ou poster sur Slack pour le declencher à la main.
      paiement_service.tax_and_payout
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
    full_params = checkout_inventory_params.merge(checkout_at: DateTime.now, status: :checked_out)
    if @inventory.update(full_params) && reservation.passed!
      ReservationMailer.ending_survey_for_user(reservation).deliver_now
      ReservationMailer.ending_survey_for_host(reservation).deliver_now
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

  def checkout_inventory_params
    params.require(:inventory).permit(:remark)
  end
end
