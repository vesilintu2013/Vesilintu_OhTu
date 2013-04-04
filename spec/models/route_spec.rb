require 'spec_helper'

describe "Route" do
  it "should have a valid factory" do
    route = FactoryGirl.create(:route)
    route.should be_valid
  end
end
