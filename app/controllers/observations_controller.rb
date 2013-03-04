class ObservationsController < ApplicationController

  def index
    @observations = Observation.paginate(:page => params[:page])
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
    # Let the model decide which params are search parameters 
    @observations = Observation.search(params).paginate(:page => params[:page])
  end
end
