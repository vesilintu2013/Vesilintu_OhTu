require 'spec_helper'

describe "Observation pages" do
  subject { page }

	describe "index page" do
	  before do
			FactoryGirl.create(:observation, :year => "1987")
			FactoryGirl.create(:observation, :year => "1988")
			FactoryGirl.create(:observation, :year => "1999")
			FactoryGirl.create(:observation, :year => "2000")
			FactoryGirl.create(:observation, :year => "2002")
			FactoryGirl.create(:observation, :year => "2011")
		  visit observations_path
	 end

		it { should have_selector('h1', :text => "Kaikki havainnot") }

		it "should show all observations" do
		  Observation.all.each do |observation|
			  page.should have_selector('li', text: "#{observation.year}")
			end
		end
	end

	describe "show Observation page" do
	  before do
		  observation = FactoryGirl.create(:observation)
			visit observation_path(observation)
	  end

	  it { should have_selector('h1', :text => "Havainnon tiedot") }

	end
end
