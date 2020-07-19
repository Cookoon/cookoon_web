module Admin
  class CookoonsController < ApplicationController
    # not necessary because it is specified directly in routes
    # before_action :require_admin
    before_action :find_cookoon, only: %i[edit update show]
    before_action :users_collection, only: %i[new create]
    before_action :perk_spefications_collection, only: %i[new create]

    def new
      @cookoon = Cookoon.new
      authorize @cookoon, policy_class: Admin::CookoonPolicy
    end

    def create
      @cookoon = Cookoon.new(cookoon_params)
      authorize @cookoon, policy_class: Admin::CookoonPolicy
      @perks = []
      perk_specifications.each do |perk_specification|
        @perks << @cookoon.perks.build(perk_specification_id: perk_specification) if perk_specification.present?
      end
      if @cookoon.save
        redirect_to admin_cookoons_path, notice: 'Le décor a été créé !'
      else
        flash.alert = "Une erreur est survenue. Veuillez vérifier votre saisie et soumettre à nouveau le formulaire"
        render :new
      end
    end

    def show
      @perk_specifications_not_selected = PerkSpecification.where.not(id: @cookoon.perks.pluck(:perk_specification_id))
      @sample_photos = @cookoon.photos.sample(4)
    end

    def index
      @cookoons_approved = cookoons.where(status: "approved")
      @cookoons_suspended = cookoons.where(status: "suspended")
      @cookoons_under_review = cookoons.where(status: "under_review")
    end

    def edit
    end

    def update
      if @cookoon.update(cookoon_params)
        redirect_to admin_cookoon_path(@cookoon), notice: 'Le Cookoon a été édité !'
      else
        flash.alert = "Une erreur est survenue. Veuillez vérifier votre saisie et soumettre à nouveau le formulaire"
        render :edit
      end
    end

    private

    def cookoon_params
      params.require(:cookoon).permit(
        :user_id, :name, :surface, :price, :address, :capacity, :category,
        :digicode, :building_number, :floor_number, :door_number,
        :wifi_network, :wifi_code, :caretaker_instructions, :status,
        :description, :citation, :main_photo, :long_photo,
        :architect_name, :architect_title, :architect_url, :architect_build_year,
        photos: []
      )
    end

    def perk_params
      params.require(:cookoon).permit(perk_ids: [])
    end

    def perk_specifications
      perk_params[:perk_ids]
    end

    # def require_admin
    #   current_user.admin == true
    # end

    def find_cookoon
      @cookoon = Cookoon.find(params[:id]).decorate
      authorize @cookoon, policy_class: Admin::CookoonPolicy
    end

    def cookoons
      policy_scope([:admin, Cookoon]).includes(:user)
    end

    def users_collection
      @users = User.all.map { |user| [user.email, user.id] }
    end

    def perk_spefications_collection
      @perk_specifications = PerkSpecification.all.map { |perk| [("<i class='mr-1 #{perk.icon_name}'></i> #{perk.name}").html_safe, perk.id] }
    end
  end
end
