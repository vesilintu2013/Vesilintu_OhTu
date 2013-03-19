require 'spec_helper'

describe Observation do
  
  describe "search method" do
    before do
      place_a = FactoryGirl.create(:place)
      place_b = FactoryGirl.create(:place, :observation_place_name => "TESTIPAIKKA")
      place_c = FactoryGirl.create(:place, :observation_place_number => "10")
      place_d = FactoryGirl.create(:place)
      route_a = FactoryGirl.create(:route, :route_number => "9005", :year => "2000")
      route_b = FactoryGirl.create(:route, :year => "2000")
      route_c = FactoryGirl.create(:route)
      route_d = FactoryGirl.create(:route)
      @observation_a = FactoryGirl.create(:observation,
                                          :route_id => route_a.id,
                                          :place_id => place_a.id,
                                          :year => route_a.year)
      @observation_b = FactoryGirl.create(:observation,
                                          :route_id => route_b.id,
                                          :place_id => place_b.id,
                                          :year => route_b.year)
      @observation_c = FactoryGirl.create(:observation,
                                          :route_id => route_c.id,
                                          :place_id => place_c.id)
      @observation_d = FactoryGirl.create(:observation,
                                          :route_id => route_d.id,
                                          :place_id => place_d.id,
                                          :observer_id => "66")
    end

    it "finds records by route number" do
      Observation.search("route_number" => "9005").should == [@observation_a]
    end

    it "finds records by year" do
      Observation.search("year" => "2000").should == [@observation_a, @observation_b]
    end

    it "finds records by observation place number" do
      Observation.search("observation_place_number" => "10").should == [@observation_c]
    end

    it "finds records by observer id" do
      Observation.search("observer_id" => "66").should == [@observation_d]
    end

    it "finds records by observation place name" do
      Observation.search("observation_place_name" => "testipaikka").should == [@observation_b]
    end

    it "finds records by a combination of search terms" do
      Observation.search("route_number" => "9005",
                         "year" => "2000").should == [@observation_a]
    end
  end
end
