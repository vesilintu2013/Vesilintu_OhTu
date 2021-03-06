require 'spec_helper'

describe "Place" do
  describe "validations" do

    before do
      route = FactoryGirl.create(:route)
      @place = FactoryGirl.create(:place, :route_id => route.id)
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

    describe "when nnn coordinate is empty" do
      before { @place.nnn_coordinate = " " }
      it { should_not be_valid }
    end

    describe "when eee coordinate is empty" do
      before { @place.eee_coordinate = " " }
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

    describe "when area_covers_fully is not a number" do
      before { @place.area_covers_fully = "boo" }
      it { should_not be_valid }
    end

    describe "when biotope_class is not a number" do
      before { @place.biotope_class = "asd" }
      it { should_not be_valid }
    end

    describe "when biotope_class is too small" do
      before { @place.biotope_class = 0 }
      it { should_not be_valid }
    end

    describe "when biotope_class is too large" do
      before { @place.biotope_class = 9 }
      it { should_not be_valid }
    end

    describe "when biotope_class is nil" do
      before { @place.biotope_class = nil }
      it { should be_valid }
    end
  end

  describe "rktl validations" do

    before do
      @place = FactoryGirl.create(:rktl_place)
    end

    subject { @place }

    it { should be_valid }

    describe "when observation place number is empty" do
      before { @place.observation_place_number = " " }
      it { should_not be_valid }
    end

    describe "when observation place number is not a number" do
      before { @place.observation_place_number = "booh" }
      it { should_not be_valid }
    end

    describe "when nnn coordinate is empty" do
      before { @place.nnn_coordinate = " " }
      it { should_not be_valid }
    end

    describe "when eee coordinate is empty" do
      before { @place.eee_coordinate = " " }
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

  end
end
