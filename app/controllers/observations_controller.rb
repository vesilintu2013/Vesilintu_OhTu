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
    search_terms = { :route_number => params[:route_number],
                     :year => params[:year],
                     :observation_place_number => params[:observation_place_number],
                     :observer_id => params[:observer_id] }
    @observations = Observation.search(search_terms)
  end
end
