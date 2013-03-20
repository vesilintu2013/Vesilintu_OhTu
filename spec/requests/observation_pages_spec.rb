        # encoding: UTF-8
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
            observation = FactoryGirl.create(:observation)
            bird = FactoryGirl.create(:bird)
            count = FactoryGirl.create(:count, :observation_id => observation.id, :bird_id => bird.id, :count => "10")

            before do
              visit observation_path(observation)
            end

            it { should have_selector('h1', :text => "Havainnon tiedot") }

            it { should have_selector('li', :text => 
                        "Reitin numero: #{observation.route_number}") }
            it { should have_selector('li', :text => 
                        "Vuosi: #{observation.year}") }
            it { should have_selector('li', :text => 
		            "Reitin paikan numero: #{observation.observation_place_number}") }
	  it { should have_selector('li', :text =>
		            "Havainnoijatunnus: #{observation.observer_id}") }
		it { should have_selector('li', :text =>
		            "Kuntakoodi: #{observation.municipal_code}") }
	  it { should have_selector('li', :text =>
								"NNN-koordinaatti: #{observation.nnn_coordinate}") }
		it { should have_selector('li', :text =>
								"EEE-koordinaatti: #{observation.eee_coordinate}") }
	  it { should have_selector('li', :text =>
		            "Biotooppiluokka: #{observation.biotope_class}") }
		it { should have_selector('li', :text =>
		            "Reitin edustavuus: #{observation.route_representative_class}") }
		it { should have_selector('li', :text =>
								"Pistelaskentapaikkojen määrä reitillä: #{observation.spot_observation_place_count}") }
	  it { should have_selector('li', :text =>
								"Kiertolaskentapaikkojen määrä reitillä: #{observation.roaming_observation_place_count}") }
	  it { should have_selector('li', :text =>
		            "Havaintopaikan nimi: #{observation.observation_place_name}") }
	  it { should have_selector('li', :text =>
		            "1. laskentakerran pvm: #{observation.first_observation_date}") }
	  it { should have_selector('li', :text =>
		            "2. laskentakerran pvm: #{observation.second_observation_date}") }
	  it { should have_selector('li', :text =>
		            "1. laskentakerran aloitustunti: #{observation.first_observation_hour}") }
	  it { should have_selector('li', :text =>
		            "2. laskentakerran aloitustunti: #{observation.second_observation_hour}") }
	  it { should have_selector('li', :text =>
		            "1. laskentakerran kesto: #{observation.first_observation_duration}") }
	  it { should have_selector('li', :text =>
		            "2. laskentakerran kesto: #{observation.second_observation_duration}") }
	  it { should have_selector('li', :text =>
		            "Koko vesistön ala: #{observation.water_system_area}") }
	  it { should have_selector('li', :text =>
		            "Laskentapaikan ala: #{observation.place_area}") }
	  it { should have_selector('li', :text =>
                "Laskentapaikka kattoi koko vesistön: #{observation.area_covers_fully}") }
	  it { should have_selector('li', :text =>
		            "Koko vesistön kattavat paikat alkaen: #{observation.covering_area_beginning}") }
	  it { should have_selector('li', :text =>
		            "Koko vesistön kattavat paikat päättyen: #{observation.covering_area_end}") }
	  it { should have_selector('li', :text =>
		            "Pistelaskenta? #{observation.spot_counting}") }
	  it { should have_selector('li', :text =>
		            "Käytettiinkö kaukoputkea? #{observation.binoculars}") }
	  it { should have_selector('li', :text =>
		            "Käytettiinkö venettä? #{observation.boat}") }
    it { should have_selector('li', :text =>
                "#{bird.abbr}: 10") }
	end

  describe "search page" do
    before do
			FactoryGirl.create(:observation, :year => "1987")
			FactoryGirl.create(:observation, :year => "1988",
                                       :observation_place_name => 'TESTIPAIKKA')
			FactoryGirl.create(:observation, :year => "1999",
                                       :route_number => 6666)
			FactoryGirl.create(:observation, :year => "2000",
                                       :observer_id => '555')
			FactoryGirl.create(:observation, :year => "2002",
                                       :observation_place_number => '10')
			FactoryGirl.create(:observation, :year => "2011")
    end

    it "should find results by year" do
      visit observations_search_path(:year => '1988') 
      page.should have_selector('li', :text => "1988")
      page.should_not have_selector('li', :text => "1987")
    end

    it "should find results by route number" do
      visit observations_search_path(:route_number => '6666')
      page.should have_selector('li', :text => '1999')
      page.should_not have_selector('li', :text => '1987')
    end

    it "should find results by observer id" do
      visit observations_search_path(:observer_id => '555')
      page.should have_selector('li', :text => '2000')
      page.should_not have_selector('li', :text => '1999')
    end

    it "should find results by observation place number" do
      visit observations_search_path(:observation_place_number => '10')
      page.should have_selector('li', :text => '2002')
      page.should_not have_selector('li', :text => '2000')
    end

    it "should find results by observation place name" do
      visit observations_search_path(:observation_place_name => 'Testipaikka')
      page.should have_selector('li', :text => '1988')
      page.should_not have_selector('li', :text => '1999')
    end
  end
end
