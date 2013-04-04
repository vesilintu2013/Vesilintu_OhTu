require 'spec_helper'

describe "Route" do
  describe "validations" do

    before do
      @route = FactoryGirl.create(:route)
    end

    subject { @route }

    it { should be_valid }

    describe "when route number is empty" do
      before { @route.route_number = " " }
      it { should_not be_valid }
    end

    describe "when year is not present" do
      before { @route.year = " " }
      it { should_not be_valid }
    end

    describe "when year is not a number" do
      before { @route.year = "booyah" }
      it { should_not be_valid }
    end

    describe "when year is too large" do
      before { @route.year = Date.today.year + 1 }
      it { should_not be_valid }
    end

    describe "when year is too small" do
      before { @route.year = 1985 }
      it { should_not be_valid }
    end

    describe "when municipal code is too long" do
      before { @route.municipal_code = "HELSINK" }
      it { should_not be_valid }
    end

    describe "when municipal code is empty" do
      before { @route.municipal_code = " " }
      it { should_not be_valid }
    end

    describe "when water system area is too large" do
      before { @route.water_system_area = "10000.0" }
      it { should_not be_valid }
    end

    describe "when water system area is empty" do
      before { @route.water_system_area = " " }
      it { should be_valid }
    end

    describe "when water system area is not a number" do
      before { @route.water_system_area = "lol" }
      it { should_not be_valid }
    end
  end
end
