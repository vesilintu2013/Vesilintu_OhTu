require 'spec_helper'

describe Observation do
  
  describe "search method" do
    before do
      @observation_a = FactoryGirl.create(:observation,
                                          :route_number => "9005",
                                          :year => "2000")
      @observation_b = FactoryGirl.create(:observation,
                                          :year => "2000",
                                          :observation_place_name => "TESTIPAIKKA")
      @observation_c = FactoryGirl.create(:observation,
                                          :observation_place_number => "10")
      @observation_d = FactoryGirl.create(:observation,
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
