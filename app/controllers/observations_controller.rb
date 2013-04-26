require 'kirjekyyhky'
class ObservationsController < ApplicationController
  include Kirjekyyhky
  skip_before_filter :check_auth, :only => [:validate]
  before_filter :kirjekyyhky_basic_auth, :only => [:validate]

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

  private
    def kirjekyyhky_basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == KIRJEKYYHKY_USERNAME and password == KIRJEKYYHKY_PASSWORD
      end
    end
end
