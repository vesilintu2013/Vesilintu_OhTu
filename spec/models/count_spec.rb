require 'spec_helper'

describe Count do
  it "should have a valid factory" do
    count = FactoryGirl.create(:count)
    count.should be_valid
  end
end
