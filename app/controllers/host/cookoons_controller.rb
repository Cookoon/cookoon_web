module Host
  class CookoonsController < ApplicationController
    include DatetimeHelper

    before_action :find_cookoon, only: %i[show edit update]
    before_action :perk_specifications_collection, only: %i[new create edit update]
    before_action :sample_photos, only: %i[show edit]

    # def show
    #   @reservation.select_cookoon!(@cookoon)
    #   @chefs = policy_scope(Chef).includes(:menus).decorate
    # end

    def show
      if @cookoon.geocoded?
        @marker = {
          lat: @cookoon.latitude,
          lng: @cookoon.longitude
        }
      end
    end

    def new
      @cookoon = Cookoon.new
      authorize @cookoon, policy_class: Host::CookoonPolicy
    end

    def create
      @cookoon = current_user.cookoons.new(cookoon_params)
      authorize @cookoon, policy_class: Host::CookoonPolicy
      @cookoon.status = "under_review"
      build_perks

      if @cookoon.save
        redirect_to host_cookoon_path(@cookoon)
        # if current_user.stripe_account_id?
        #   redirect_to home_path
        # else
        #   flash[:notice] = "Vous avez presque terminé ! Pour que votre Cookoon soit visible et recevoir des paiements, \
        #     vous devez connecter votre compte à notre organisme de paiement partenaire."
        #   redirect_to new_stripe_account_path
        # end
      else
        # if @cookoon.errors.messages[:user].present?
        #   flash.now.alert = @cookoon.errors.messages[:user].join(" / ")
        # else
        #   flash.now.alert = "Une erreur est survenue. Veuillez vérifier votre saisie et soumettre à nouveau le formulaire"
        # end
        flash.now.alert = "Une erreur est survenue. Veuillez vérifier votre saisie et soumettre à nouveau le formulaire"
        render :new
      end
    end

    def edit; end

    def update
      @cookoon.status = "under_review"
      delete_perks
      build_perks
      if @cookoon.update(cookoon_params)
        redirect_to host_cookoon_path(@cookoon)#, notice: 'Votre Cookoon a été édité !'
      else
        flash.now.alert = "Une erreur est survenue. Veuillez vérifier votre saisie et soumettre à nouveau le formulaire"
        render :new
      end
    end

    private

    def find_cookoon
      @cookoon = Cookoon.find(params[:id]).decorate
      authorize @cookoon, policy_class: Host::CookoonPolicy
    end

    def cookoon_params
      params.require(:cookoon).permit(
        :name, :surface, :price, :address, :capacity, :capacity_standing, :category,
        :digicode, :building_number, :floor_number, :door_number,
        :wifi_network, :wifi_code, :caretaker_instructions, :citation,
        :main_photo, :long_photo, :description, :architect_name,
        :architect_title, :architect_url, :architect_build_year,
        photos: []
      )
    end

    def perk_params
      params.require(:cookoon).permit(perk_ids: [])
    end

    def perk_specifications_collection
      @perk_specifications = PerkSpecification.all.map { |perk| [("<i class='mr-1 #{perk.icon_name}'></i> #{perk.name}").html_safe, perk.id.to_int] }
    end

    def sample_photos
      @sample_photos = @cookoon.sample_photos
    end

    def current_cookoon_perks
      @cookoon.perks.pluck(:perk_specification_id).map { |element| element.to_s }
    end

    def new_cookoon_perks
      perk_params[:perk_ids].reject { |perk_id| perk_id.blank? }
    end

    def build_perks
      perks_to_create = new_cookoon_perks - current_cookoon_perks
      perks_to_create.each do |perk_specification_id|
        @cookoon.perks.build(perk_specification_id: perk_specification_id.to_i)
      end
    end

    def delete_perks
      perks_to_delete = current_cookoon_perks - new_cookoon_perks
      perks_to_delete.each do |perk_specification_id|
        Perk.find_by(cookoon: @cookoon, perk_specification_id: perk_specification_id.to_i).delete
      end
    end

  end
end
