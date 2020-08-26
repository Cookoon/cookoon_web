module Admin
  class ServicesController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_reservation, only: %i[new create edit update]
    before_action :find_service, only: %i[edit update]

    def new
      @service = Service.new(reservation: @reservation)
      authorize @service, policy_class: Admin::ServicePolicy
    end

    def create
      @service = Service.new(reservation: @reservation)
      authorize @service, policy_class: Admin::ServicePolicy
      @service.assign_attributes(service_params_category)
      if @service.save
        @reservation.assign_prices
        if @reservation.save
          flash[:notice] = "Le service a bien été créé"
          redirect_to edit_admin_reservation_service_path(@reservation, @service)
        else
          flash[:alert] = "Il y a eu un problème"
          render :edit
        end
      else
        flash[:alert] = "Il y a eu un problème"
        render :new
      end
    end

    def edit
    end

    def update
      if @service.update(service_params)
        @reservation.assign_prices
        if @reservation.save
          flash[:notice] = "Les modifications ont bien été enregistrées"
          redirect_to admin_reservation_path(@reservation)
        else
          flash[:alert] = "Il y a eu un problème"
          render :edit
        end
      else
        flash[:alert] = "Il y a eu un problème"
        render :edit
      end
    end

    private

    def find_reservation
      @reservation = Reservation.find(params[:reservation_id]).decorate
    end

    def find_service
      @service = Service.find(params[:id])
      authorize @service, policy_class: Admin::ServicePolicy
    end

    def service_params
      params.require(:service).permit(:name, :margin, :quantity_base, :base_price, :quantity, :unit_price)
    end

    def service_params_category
      params.require(:service).permit(:category)
    end

  end
end
