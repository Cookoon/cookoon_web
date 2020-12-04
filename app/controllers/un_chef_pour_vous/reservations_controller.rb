class UnChefPourVous::ReservationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[update show create edit select_cookoon select_menu]
  before_action :find_reservation, only: %i[select_cookoon select_menu]
  before_action :find_cookoon, only: %i[select_cookoon]

  def show
    @reservation = Reservation.find(params[:id]).decorate
  end

  def edit
    @reservation = Reservation.find(params[:id]).decorate
    @amex_code = AmexCode.new(reservation: @reservation)
  end

  def update
    @reservation = Reservation.find(params[:id]).decorate

    if params[:amex_code].present?
      @amex_code = AmexCode.find_by(code: params[:amex_code][:code], email: params[:amex_code][:email])
    else
      @amex_code = AmexCode.find_by(code: params[:code], email: params[:email])
    end

    if @amex_code.blank?
      flash.now.alert = "Ce code ou cet e-mail est incorrect."
      render :edit
    elsif @amex_code.already_used?
      flash.now.alert = "Ce code a déjà été utilisé."
      render :edit
    else
      @amex_code.reservation = @reservation
      if @amex_code.update(amex_code_params)
        @reservation.ask_amex!
        redirect_to un_chef_pour_vous_root_path, notice: "Votre réservation a bien été prise en compte. Nous vous recontacterons dès que celle-ci sera validée par votre hôte et votre chef."
      else
        render :edit
      end
    end
  end

  def create
    @reservation = Reservation.new(reservation_params.merge(category: 'amex', people_count: 2))
    if @reservation.save
      redirect_to un_chef_pour_vous_reservation_cookoons_path(@reservation)
    else
      flash.alert = "Votre réservation n'est pas valide, vous devez remplir tous les champs."
      redirect_to un_chef_pour_vous_root_path
    end
  end

  def select_cookoon
    if @reservation.pending?
      if @reservation.select_cookoon!(@cookoon)
        redirect_to un_chef_pour_vous_reservation_cookoon_path(@reservation, @cookoon)
      else
        redirect_to un_chef_pour_vous_reservation_cookoons_path(@reservation), alert: "Une erreur s'est produite, veuillez essayer à nouveau"
      end
    else
      redirect_to un_chef_pour_vous_reservation_cookoon_path(@reservation, @cookoon)
    end
  end

  def select_menu
    @reservation.select_menu!(Menu.find(params[:menu_id]))
    @reservation.update(menu_status: "selected")
    redirect_to un_chef_pour_vous_reservation_path(@reservation), flash: { check_of_chef_availability_needed: true }
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_at, :type_name)
  end

  def amex_code_params
    if params[:amex_code].present?
      params.require(:amex_code).permit(:first_name, :last_name, :phone_number)
    else
      params.permit(:first_name, :last_name, :phone_number)
    end
  end

  def find_reservation
    @reservation = Reservation.find(params[:reservation_id]).decorate
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end
end
