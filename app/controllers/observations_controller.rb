class ObservationsController < ApplicationController
  def index
    @observations = Observation.find_all
  end

  def show
    @observation = Observation.find(params[:id])
  end
end
