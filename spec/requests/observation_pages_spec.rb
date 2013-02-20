require 'spec_helper'

describe "Observation pages" do
  subject { page }

	describe "index page" do
	  before do
		  visit observations_path
	 end

		it { should have_selector('h1', :text => "Kaikki havainnot") }
	end
end
