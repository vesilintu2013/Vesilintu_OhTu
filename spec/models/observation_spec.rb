require 'spec_helper'

describe Observation do
  
  describe "validations" do
    before do
      @observation = FactoryGirl.create(:observation, :source => "museum")
    end

    subject {@observation }

    it { should be_valid }
    
    describe "when year is not present" do
      before {@observation.year = " " }
      it { should_not be_valid }
    end

    describe "when year is not a number" do
      before { @observation.year = "booyah" }
      it { should_not be_valid }
    end

    describe "when year is too large" do
      before { @observation.year = Date.today.year + 1 }
      it { should_not be_valid }
    end

    describe "when year is too small" do
      before { @observation.year = 1985 }
      it { should_not be_valid }
    end

    describe "when observer id is empty" do
      before { @observation.observer_id = " " }
      it { should_not be_valid }
    end

    describe "when first observation hour is empty" do
      before { @observation.first_observation_hour = " " }
      it { should be_valid }
    end

    describe "when first observation hour is too large" do
      before { @observation.first_observation_hour = "24" }
      it { should_not be_valid }
    end

    describe "when first observation hour is not a number" do
      before { @observation.first_observation_hour = "fudge" }
      it { should_not be_valid }
    end
 
    describe "when second observation hour is empty" do
      before { @observation.second_observation_hour = " " }
      it { should be_valid }
    end

    describe "when second observation hour is too large" do
      before { @observation.second_observation_hour = "24" }
      it { should_not be_valid }
    end

    describe "when second observation hour is not a number" do
      before { @observation.second_observation_hour = "fudge" }
      it { should_not be_valid }
    end

    describe "when first observation duration is empty" do
      before { @observation.first_observation_duration = " " }
      it { should be_valid }
    end

    describe "when first observation duration is too large" do
      before { @observation.first_observation_duration = "1000" }
      it { should_not be_valid }
    end

    describe "when first observation duration is not a number" do
      before { @observation.first_observation_duration = "fudge" }
      it { should_not be_valid }
    end
 
    describe "when second observation duration is empty" do
      before { @observation.second_observation_duration = " " }
      it { should be_valid }
    end

    describe "when second observation duration is too large" do
      before { @observation.second_observation_duration = "1000" }
      it { should_not be_valid }
    end

    describe "when second observation duration is not a number" do
      before { @observation.second_observation_duration = "fudge" }
      it { should_not be_valid }
    end
    
    describe "when gullbirds is nil" do
      before { @observation.gullbirds = nil }
      it { should_not be_valid }
    end

    describe "when waders_eurasian_bittern is nil" do
      before { @observation.waders_eurasian_bittern = nil }
      it { should_not be_valid }
    end

    describe "when passerine is nil" do
      before { @observation.passerine = nil }
      it { should_not be_valid }
    end

    describe "when TipuApi returns an empty list of observers" do
      before { TipuApi::Interface.stub(:ringers).and_return("") }
      it { should_not be_valid }
    end

    describe "when TipuApi return a list of observers that does not contain this observer" do
      before { TipuApi::Interface.stub(:ringers).and_return({ "ringer" => { "id" => 1234 } }) }
      it { should_not be_valid }
    end
    
    describe "when observer is not found in TipuApi" do
      before { TipuApi::Interface.stub(:ringers).and_return("") }
      
      describe "and TipuApi observer-synonyms for this observer is empty" do
        it { should_not be_valid }
      end

      describe "and TipuApi observer-synonyms for this observer does not contain this observer" do
        before { TipuApi::Interface.stub(:observer_synonyms).and_return({ "synonym" => [{ "id" => 123 }, {"id" => 234}] }) }
        it { should_not be_valid }
      end
      
      describe "but TipuApi observer-synonyms contains this observer" do
        before do
          TipuApi::Interface.stub(:observer_synonyms).and_return({ "synonym" => { "id" => @observation.observer_id, "correct-id" => 666 } })
        end

        it { should be_valid }
      end
    end
  end

  describe "rktl validations" do
    before do
      @observation = FactoryGirl.create(:rktl_observation)
    end

    subject {@observation }

    it { should be_valid }
    
    describe "when year is not present" do
      before {@observation.year = " " }
      it { should_not be_valid }
    end

    describe "when year is not a number" do
      before { @observation.year = "booyah" }
      it { should_not be_valid }
    end

    describe "when year is too large" do
      before { @observation.year = Date.today.year + 1 }
      it { should_not be_valid }
    end

    describe "when year is too small" do
      before { @observation.year = 1985 }
      it { should_not be_valid }
    end

    describe "when first observation hour is empty" do
      before { @observation.first_observation_hour = " " }
      it { should be_valid }
    end

    describe "when first observation hour is too large" do
      before { @observation.first_observation_hour = "24" }
      it { should_not be_valid }
    end

    describe "when first observation hour is not a number" do
      before { @observation.first_observation_hour = "fudge" }
      it { should_not be_valid }
    end
 
    describe "when second observation hour is empty" do
      before { @observation.second_observation_hour = " " }
      it { should be_valid }
    end

    describe "when second observation hour is too large" do
      before { @observation.second_observation_hour = "24" }
      it { should_not be_valid }
    end

    describe "when second observation hour is not a number" do
      before { @observation.second_observation_hour = "fudge" }
      it { should_not be_valid }
    end

    describe "when first observation duration is empty" do
      before { @observation.first_observation_duration = " " }
      it { should be_valid }
    end

    describe "when first observation duration is too large" do
      before { @observation.first_observation_duration = "1000" }
      it { should_not be_valid }
    end

    describe "when first observation duration is not a number" do
      before { @observation.first_observation_duration = "fudge" }
      it { should_not be_valid }
    end
 
    describe "when second observation duration is empty" do
      before { @observation.second_observation_duration = " " }
      it { should be_valid }
    end

    describe "when second observation duration is too large" do
      before { @observation.second_observation_duration = "1000" }
      it { should_not be_valid }
    end

    describe "when second observation duration is not a number" do
      before { @observation.second_observation_duration = "fudge" }
      it { should_not be_valid }
    end
  end

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
