class ObservationsController < ApplicationController

  def index
    @observations = Observation.all
  end

  def show
    begin
      @observation = Observation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Record not found in database"
      redirect_to observations_path
    end
  end

  def search
	  @observations = Observation.search(params[:search_terms])
	end
end
