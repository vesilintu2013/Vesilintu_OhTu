require 'spec_helper'

describe "Place" do
  describe "validations" do

    before do
      @place = FactoryGirl.create(:place)
    end

    subject { @place }

    it { should be_valid }

    describe "when observation place number is too large" do
      before { @place.observation_place_number = "1000" }
      it { should_not be_valid }
    end

    describe "when observation place number is empty" do
      before { @place.observation_place_number = " " }
      it { should_not be_valid }
    end

    describe "when observation place number is not a number" do
      before { @place.observation_place_number = "booh" }
      it { should_not be_valid }
    end

    describe "when observation place name is empty" do
      before { @place.observation_place_name = " " }
      it { should_not be_valid }
    end

    describe "when place area is too large" do
      before { @place.place_area = "10000.0" }
      it { should_not be_valid }
    end

    describe "when place area is empty" do
      before { @place.place_area = " " }
      it { should be_valid }
    end

    describe "when place area is not a number" do
      before { @place.place_area = "lol" }
      it { should_not be_valid }
    end

    describe "when area_covers_fully is too large" do
      before { @place.area_covers_fully = "3" }
      it { should_not be_valid }
    end

    describe "when area_covers_fully is empty" do
      before { @place.area_covers_fully = " " }
      it { should_not be_valid }
    end

    describe "when area_covers_fully is not a number" do
      before { @place.area_covers_fully = "boo" }
      it { should_not be_valid }
    end
  end
end
