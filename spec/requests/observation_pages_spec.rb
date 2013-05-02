        # encoding: UTF-8
        # This request spec skips all validations when saving models to the database.
        # This is an ugly hack to avoid external TipuApi validation calls as the
        # TipuApi stubs in spec_helper.rb do not replace the actual TipuApi module 
        # methods in this request spec.
        require 'spec_helper'
        
        describe "Observation pages" do
          subject { page }

          describe "index page" do
            before do
              route1 = FactoryGirl.build(:route, :year => "1987")
              route1.save(:validate => false)
              route2 = FactoryGirl.build(:route, :year => "1988")
              route2.save(:validate => false)
              route3 = FactoryGirl.build(:route, :year => "2000")
              route3.save(:validate => false)
              place1 = FactoryGirl.build(:place, :route_id => route1.id, :source => "museum") 
              place1.save(:validate => false)
              place2 = FactoryGirl.build(:place, :route_id => route2.id, :source => "museum") 
              place2.save(:validate => false)
              place3 = FactoryGirl.build(:place, :route_id => route3.id, :source => "museum") 
              place3.save(:validate => false)
              FactoryGirl.build(:observation, :year => route1.year, :route_id => route1.id, :place_id => place1.id, :source => "museum").save(:validate => false)
              FactoryGirl.build(:observation, :year => route2.year, :route_id => route2.id, :place_id => place2.id, :source => "museum").save(:validate => false)
              FactoryGirl.build(:observation, :year => route3.year, :route_id => route3.id, :place_id => place3.id, :source => "museum").save(:validate => false)
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
              route = FactoryGirl.build(:route)
              route.save(:validate => false)
              place = FactoryGirl.build(:place, :route_id => route.id)
              place.save(:validate => false)
              @observation = FactoryGirl.build(:observation, :route_id => route.id, :place_id => place.id, :source => "museum")
              @observation.save(:validate => false)
              FactoryGirl.build(:count, :observation_id => @observation.id, :abbr => "anapla", :count => "10").save(:validate => false)
              visit observation_path(@observation)
            end

            it { should have_selector('h1', :text => "Havainnon tiedot") }

            it { should have_selector('li', :text => 
                        "Reitin numero: #{@observation.route.route_number}") }
            it { should have_selector('li', :text => 
                        "Vuosi: #{@observation.year}") }
            it { should have_selector('li', :text => 
		            "Reitin paikan numero: #{@observation.place.observation_place_number}") }
            it { should have_selector('li', :text =>
                "Havainnoijatunnus: #{@observation.observer_id}") }
            it { should have_selector('li', :text =>
		            "Kuntakoodi: #{@observation.route.municipal_code}") }
            it { should have_selector('li', :text =>
								"NNN-koordinaatti: #{@observation.place.nnn_coordinate}") }
           	it { should have_selector('li', :text =>
								"EEE-koordinaatti: #{@observation.place.eee_coordinate}") }
            it { should have_selector('li', :text =>
		            "Biotooppiluokka: #{@observation.place.biotope_class}") }
            it { should have_selector('li', :text =>
		            "Reitin edustavuus: #{@observation.route.route_representative_class}") }
            it { should have_selector('li', :text =>
								"Pistelaskentapaikkojen määrä reitillä: #{@observation.route.spot_observation_place_count}") }
            it { should have_selector('li', :text =>
								"Kiertolaskentapaikkojen määrä reitillä: #{@observation.route.roaming_observation_place_count}") }
            it { should have_selector('li', :text =>
		            "Havaintopaikan nimi: #{@observation.place.observation_place_name}") }
            it { should have_selector('li', :text =>
		            "1. laskentakerran pvm: #{@observation.first_observation_date}") }
            it { should have_selector('li', :text =>
		            "2. laskentakerran pvm: #{@observation.second_observation_date}") }
            it { should have_selector('li', :text =>
		            "1. laskentakerran aloitustunti: #{@observation.first_observation_hour}") }
            it { should have_selector('li', :text =>
		            "2. laskentakerran aloitustunti: #{@observation.second_observation_hour}") }
            it { should have_selector('li', :text =>
		            "1. laskentakerran kesto: #{@observation.first_observation_duration}") }
            it { should have_selector('li', :text =>
		            "2. laskentakerran kesto: #{@observation.second_observation_duration}") }
            it { should have_selector('li', :text =>
		            "Koko vesistön ala: #{@observation.route.water_system_area}") }
            it { should have_selector('li', :text =>
		            "Laskentapaikan ala: #{@observation.place.place_area}") }
            it { should have_selector('li', :text =>
                "Laskentapaikka kattoi koko vesistön: #{@observation.place.area_covers_fully}") }
            it { should have_selector('li', :text =>
		            "Koko vesistön kattavat paikat alkaen: #{@observation.place.covering_area_beginning}") }
            it { should have_selector('li', :text =>
		            "Koko vesistön kattavat paikat päättyen: #{@observation.place.covering_area_end}") }
            it { should have_selector('li', :text =>
		            "Pistelaskenta? #{@observation.spot_counting}") }
            it { should have_selector('li', :text =>
		            "Käytettiinkö kiikaria? #{@observation.binoculars}") }
            it { should have_selector('li', :text =>
		            "Käytettiinkö venettä? #{@observation.boat}") }
            it { should have_selector('li', :text =>
                "anapla: 10") }
	end

  describe "search page" do
    before do
      route_a = FactoryGirl.build(:route, :year => "1987")
      route_a.save(:validate => false)
      place_a = FactoryGirl.build(:place)
      place_a.save(:validate => false)
      place_b = FactoryGirl.build(:place, :observation_place_name => 'TESTIPAIKKA')
      place_b.save(:validate => false)
      route_b = FactoryGirl.build(:route, :year => "1988")
      route_b.save(:validate => false)
      route_c = FactoryGirl.build(:route, :year => "1999", :route_number => "6666")
      route_c.save(:validate => false)
      place_c = FactoryGirl.build(:place)
      place_c.save(:validate => false)
      route_d = FactoryGirl.build(:route, :year => "2000")
      route_d.save(:validate => false)
      place_d = FactoryGirl.build(:place)
      place_d.save(:validate => false)
      route_e = FactoryGirl.build(:route, :year => "2002")
      route_e.save(:validate => false)
      place_e = FactoryGirl.build(:place, :observation_place_number => '10')
      place_e.save(:validate => false)
			FactoryGirl.build(:observation, :route_id => route_a.id,
                                       :place_id => place_a.id,
                                       :year => route_a.year).save(:validate => false)
			FactoryGirl.build(:observation, :route_id => route_b.id,
                                       :place_id => place_b.id,
                                       :year => route_b.year).save(:validate => false)
			FactoryGirl.build(:observation, :route_id => route_c.id,
                                       :place_id => place_c.id,
                                       :year => route_c.year).save(:validate => false)
			FactoryGirl.build(:observation, :place_id => place_d.id,
                                       :route_id => route_d.id,
                                       :year => route_d.year,
                                       :observer_id => '555').save(:validate => false)
			FactoryGirl.build(:observation, :route_id => route_e.id,
                                       :year => route_e.year,
                                       :place_id => place_e.id).save(:validate => false)
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

  describe "edit page" do
    before do
      route = FactoryGirl.build(:route)
      route.save(:validate => false)
      place = FactoryGirl.build(:place)
      place.save(:validate => false)
      @observation = FactoryGirl.build(:observation, :route_id => route.id, :place_id => place.id, :year => 1998).save(:validate => false)
    end

    it "should show the old attributes in the edit form" do
      visit edit_observation_path(@observation)
      page.should have_selector('input', :value => "1998")
    end

#    it "should update attributes on the Observation model" do
#      visit edit_observation_path(@observation)
#      fill_in 'Havainnoijanumero', with: "9000"
#      click_button "Tallenna"
#      page.should have_content "Muutokset tallennettu"
#      page.should have_content "Havainnoijatunnus: 9000"
#    end
#
#    it "should update attributes on the Route model" do
#      visit edit_observation_path(@observation)
#      fill_in "Reitin numero", with: "9000"
#      click_button "Tallenna"
#      page.should have_content "Muutokset tallennettu"
#      page.should have_content "Reitin numero: 9000"
#    end
#
#    it "should update attributes on the Place model" do
#      visit edit_observation_path(@observation)
#      fill_in "Laskentapaikan nimi", with: "Paskalampi"
#      click_button "Tallenna"
#      page.should have_content "Muutokset tallennettu"
#      page.should have_content "Havaintopaikan nimi: Paskalampi"
#    end
  end
end
