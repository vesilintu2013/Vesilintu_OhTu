require 'spec_helper'

describe ObservationsController do
  describe 'accessing the observations index page' do
    before do
      Observation.stub(:all).and_return("All Observations")
    end

    it 'should call the Observation model for all observations' do
      Observation.should_receive(:all)
      get :index
    end

    it 'should render the Observations index page' do
      get :index
      response.should render_template('index')
    end

    it 'should make the Observations available to the view' do
      get :index
      assigns(:observations).should == "All Observations"
    end
  end

  describe 'accessing the show Observation page' do
    it 'should call the Observation model method to find an Observation' do
      Observation.should_receive(:find).with('1')
      get :show, :id => '1'
    end

    describe 'when the Observation if found' do
      before do
        Observation.stub(:find).and_return("An observation")
        get :show, :id => '1'
      end

      it 'should render the show Observation page' do
        response.should render_template('show')
      end

      it 'should make the Observation available to the view' do
        assigns(:observation).should == "An observation"
      end
    end

    describe 'when the Observation is not found' do
      before do
        Observation.stub(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => 1
      end

      it 'should render the index page' do
        response.should redirect_to(observations_path)
      end

      it 'should flash an error message' do
        flash[:error].should_not be_nil
      end
    end
  end
end
