require 'kirjekyyhky'
class ObservationsController < ApplicationController
  include Kirjekyyhky
 
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

  def edit
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

  def update
    @observation = Observation.find(params[:id])
    if @observation.update_attributes(params[:observation])
      flash[:success] = "Muutokset tallennettu"
      redirect_to :action => 'show', :id => @observation
    else
      render :action => 'edit'
    end
  end

  def validate
    render xml: Kirjekyyhky::Interface.validate_form(params["form_data"]["data"])
  end
end
