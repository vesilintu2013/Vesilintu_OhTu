require 'spec_helper'

describe ObservationsController do
  describe 'accessing the observations index page' do
    it 'should call the Observation model for all observations' do
      Observation.should_receive(:find_all)
      get :index
    end

    it 'should render the Observations index page' do
      Observation.stub(:find_all)
      get :index
      response.should render_template('index')
    end

    it 'should make the Observations available to the view' do
      Observation.stub(:find_all).and_return("All Observations")
      get :index
      assigns(:observations).should == "All Observations"
    end
  end

  describe 'accessing the show Observation page' do
    it 'should call the Observation model method to find an Observation' do
      Observation.should_receive(:find).with('1')
      get :show, :id => '1'
    end

    it 'should render the show Observation page' do
      Observation.stub(:find)
      get :show, :id => '1'
      response.should render_template('show')
    end

    it 'should make the Observation available to the view' do
      Observation.stub(:find).and_return("An observation")
      get :show, :id => '1'
      assigns(:observation).should == "An observation"
    end
  end
end
