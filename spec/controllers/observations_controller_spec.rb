require 'spec_helper'

describe ObservationsController do
  describe 'accessing the observations index page' do
    before do
      Observation.stub(:paginate).and_return("All Observations")
    end

    it 'should call the Observation method paginate for all observations' do
      Observation.should_receive(:paginate)
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

  describe 'accessing the edit observation page' do
    describe 'when the Observation is found' do
      before do
        Observation.stub(:find).and_return("An observation")
        get :edit, :id => '1'
      end

      it 'should render the edit Oservation page' do
        response.should render_template('edit')
      end

      it 'should make the Observation available to the view' do
        assigns(:observation).should == "An observation"
      end
    end

    describe 'when the Observation is not found' do
      before do
        Observation.stub(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => '1'
      end

      it 'should render the index page' do
        response.should redirect_to(observations_path)
      end

      it 'should flash an error message' do
        flash[:error].should_not be_nil
      end
    end
  end

  describe "accessing the search observations page" do
    before do
      route = FactoryGirl.create(:route, :route_number => "9005")
      FactoryGirl.create(:observation, :route_id => route.id)
    end
	  
    it "should call the observation search method with right params" do
      # Need to stub nil.paginate because Observation.search returns nil
      # with the request below. No idea why. The search method
      # obviously receives the correct params as the test passes.
      nil.stub(:paginate)
      Observation.should_receive(:search).with(hash_including(:route_number => '9005'))
      get :search, :route_number => "9005"
    end

    it "should render the observations search results page" do
      get :search
      response.should render_template('search')
    end

    it "should make the search results available to the view" do
      get :search 
      assigns(:observations).should == Observation.all
    end
  end
end
