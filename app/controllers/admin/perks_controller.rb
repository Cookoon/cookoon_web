class Admin::PerksController < ApplicationController

  before_action :find_cookoon, only: %i[new create destroy]
  before_action :find_perk, only: %i[destroy]

  def new
    @perk = Perk.new
    authorize @perk, policy_class: Admin::PerkPolicy
  end

  def create
    @perk = Perk.new(perk_params)
    authorize @perk, policy_class: Admin::PerkPolicy
    @perk.cookoon = @cookoon
    if @perk.save
      redirect_to edit_admin_cookoon_path(@cookoon), notice: 'La spécification a bien été ajoutée !'
    else
      render :new
    end
  end

  def destroy
    @perk.destroy
    redirect_to edit_admin_cookoon_path(@cookoon), notice: 'La spécification a bien été supprimée !'
  end

  private

  def perk_params
    params.require(:perk).permit(:perk_specification_id)
  end

  def find_cookoon
    @cookoon = Cookoon.find(params[:cookoon_id])
  end

  def find_perk
    @perk = Perk.find(params[:id])
    authorize @perk, policy_class: Admin::PerkPolicy
  end

end
