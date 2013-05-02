FactoryGirl.define do
  factory :observation do
		year													"1986"
		observer_id										"1000"
		first_observation_date				"1986-05-11"
		second_observation_date				nil
		first_observation_hour				"7"
		first_observation_duration		"5"
		second_observation_hour		 	 	" "
		second_observation_duration		" "
		spot_counting									true
		binoculars										false
		boat													false
		gullbirds											true
		waders_eurasian_bittern				true
		passerine											true
    source                        "museum"
	end

  factory :place do
		route_id                      "1"
    nnn_coordinate								"667"
		eee_coordinate								"333"
		biotope_class									"3"
	  observation_place_number			"1"
		observation_place_name				"JUSOLANLAMPI"
	  area_covers_fully							"1"
		covering_area_beginning				nil
		covering_area_end							nil
	  place_area										"2.0"
    source                        "museum"
  end

  factory :route do
	  route_number 									"9001"
    year                          "1986"
		municipal_code								"LOHJA"
		route_representative_class		"1"
		spot_observation_place_count	"18"
		roaming_observation_place_count "0"
		water_system_area							"2.0"
  end

  factory :count do
    abbr            "anapla"
    count           "0"
    observation_id  "1"
  end
  
  factory :rktl_observation, class: Observation  do
		year													"1986"
		observer_id										nil
		first_observation_date				"1986-05-11"
		second_observation_date				nil
		first_observation_hour				"7"
		first_observation_duration		"5"
		second_observation_hour		 	 	" "
		second_observation_duration		" "
		spot_counting									nil
		binoculars									  false
		boat													nil
		gullbirds											nil
		waders_eurasian_bittern				nil
		passerine											nil
    rktl_telescope                true
    source                        "rktl"
	end

  factory :rktl_place, class: Place do
		route_id                      nil
    nnn_coordinate								"667"
		eee_coordinate								"333"
		biotope_class									"3"
	  observation_place_number			"1"
		observation_place_name				nil
	  area_covers_fully							nil
		covering_area_beginning				nil
		covering_area_end							nil
	  place_area										"2.0"
    rktl_munincipal_code           "LOHJA"
    rktl_pog_society_id           "1"
    rktl_town                     "Lohjanharju"
    rktl_zip                      "01010"
    rktl_it                       "jotain"
    rktl_map_number               1
    rktl_map_name                 "jotain"
    rktl_shore_length             5.0
    rktl_pog_zone_id              1
    rktl_project                  "jotain"
    rktl_place_not_counted        false
    rktl_other                    "jotain infoa"
    source                        "rktl" 
  end
end
