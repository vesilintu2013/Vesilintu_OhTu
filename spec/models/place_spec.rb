require 'spec_helper'

describe "Place" do
  it "should have a valid factory" do
    place = FactoryGirl.create(:place)
    place.should be_valid
  end
end
