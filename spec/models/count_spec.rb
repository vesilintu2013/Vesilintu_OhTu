require 'spec_helper'

describe Count do
  describe "validations" do
    before do
      @count = FactoryGirl.create(:count)
    end

    subject { @count }

    it { should be_valid }
    
    describe "when TipuApi returns an empty list of species" do
      before { TipuApi::Interface.stub(:species).and_return("") }
      it { should_not be_valid }
    end

    describe "when TipuApi returns a list of species that does not contain this species" do
      before { TipuApi::Interface.stub(:species).and_return({ "species" => { "id" => "BIRDIE" } }) }
      it { should_not be_valid }
    end
  end
end
