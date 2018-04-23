class EphemeralsController < ApplicationController
  before_action :find_ephemeral

  def show; end

  def pay
    # TODO
  end

  private

  def find_ephemeral
    @ephemeral = Ephemeral.find params[:id]
    authorize @ephemeral
  end
end
