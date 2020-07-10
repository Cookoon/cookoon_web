class Admin::ChefPerkSpecificationsController < ApplicationController

  before_action :find_chef_perk_specification, only: %i[destroy]

  def new
    @chef_perk_specification = ChefPerkSpecification.new
    authorize @chef_perk_specification, policy_class: Admin::ChefPerkSpecificationPolicy
  end

  def index
    @chef_perk_specifications = policy_scope([:admin, ChefPerkSpecification])
  end

  def create
    @chef_perk_specification = ChefPerkSpecification.new(chef_perk_specification_params)
    authorize @chef_perk_specification, policy_class: Admin::ChefPerkSpecificationPolicy
    if @chef_perk_specification.save
      redirect_to admin_chef_perk_specifications_path, notice: 'La spécification a bien été créée !'
    else
      render :new
    end
  end

  def destroy
    @chef_perk_specification.destroy
    redirect_to admin_chef_perk_specifications_path, notice: 'La spécification a bien été supprimée !'
  end

  private

  def chef_perk_specification_params
    params.require(:chef_perk_specification).permit(:name, :image)
  end

  def find_chef_perk_specification
    @chef_perk_specification = ChefPerkSpecification.find(params[:id])
    authorize @chef_perk_specification, policy_class: Admin::ChefPerkSpecificationPolicy
  end

end
