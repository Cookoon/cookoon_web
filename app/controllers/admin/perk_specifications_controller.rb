class Admin::PerkSpecificationsController < ApplicationController

  before_action :find_perk_specification, only: %i[destroy]

  def new
    @perk_specification = PerkSpecification.new
    authorize @perk_specification, policy_class: Admin::PerkSpecificationPolicy
  end

  def index
    @perk_specifications = policy_scope([:admin, PerkSpecification])
  end

  def create
    @perk_specification = PerkSpecification.new(perk_specification_params)
    authorize @perk_specification, policy_class: Admin::PerkSpecificationPolicy
    if @perk_specification.save
      redirect_to admin_perk_specifications_path, notice: 'La spécification a bien été créée !'
    else
      render :new
    end
  end

  def destroy
    @perk_specification.destroy
    redirect_to admin_perk_specifications_path, notice: 'La spécification a bien été supprimée !'
  end

  private

  def perk_specification_params
    params.require(:perk_specification).permit(
      :name, :icon_name
    )
  end

  def find_perk_specification
    @perk_specification = PerkSpecification.find(params[:id])
    authorize @perk_specification, policy_class: Admin::PerkSpecificationPolicy
  end

end
