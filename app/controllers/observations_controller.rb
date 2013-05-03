require 'kirjekyyhky'
require 'zip/zip'
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
    obs, @search_params = Observation.search(params)
    @observations = obs.paginate(:page => params[:page])
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

  def downloads
    places, routes, counts, observations = Observation.to_csv(params)

    t = Tempfile.new("zip_temp_file")
    Zip::ZipOutputStream.open(t.path) do |z|
      unless places.nil?
        z.put_next_entry("places.csv")
        z.write(places)
      end
      unless routes.nil?
        z.put_next_entry("routes.csv")
        z.write(routes)
      end
      unless counts.nil?
        z.put_next_entry("counts.csv")
        z.write(counts)
      end
      unless observations.nil?
        z.put_next_entry("observations.csv")
        z.write(observations)
      end
    end

    send_file t.path, :type => "application/zip", :disposition => "attachment", :filename => "export.zip"

    t.close

  end

  private

    def kirjekyyhky_basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == KIRJEKYYHKY_USERNAME and password == KIRJEKYYHKY_PASSWORD
      end
    end
end
