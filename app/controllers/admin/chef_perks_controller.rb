class Admin::ChefPerksController < ApplicationController

  before_action :find_chef, only: %i[new create destroy]
  before_action :find_chef_perk, only: %i[destroy]

  def new
    @chef_perk = ChefPerk.new
    authorize @chef_perk, policy_class: Admin::ChefPerkPolicy
  end

  def create
    @chef_perk = ChefPerk.new(chef_perk_params)
    authorize @chef_perk, policy_class: Admin::ChefPerkPolicy
    @chef_perk.chef = @chef
    if @chef_perk.save
      redirect_to admin_chef_path(@chef), notice: 'La perk a bien été ajoutée !'
    else
      render :new
    end
  end

  def destroy
    @chef_perk.destroy
    redirect_to admin_chef_path(@chef), notice: 'La perk a bien été supprimée !'
  end

  private

  def chef_perk_params
    params.require(:chef_perk).permit(:chef_perk_specification_id)
  end

  def find_chef
    @chef = Chef.find(params[:chef_id])
  end

  def find_chef_perk
    @chef_perk = ChefPerk.find(params[:id])
    authorize @chef_perk, policy_class: Admin::ChefPerkPolicy
  end

end
