FactoryGirl.define do
  factory :observation do
	  route_number 									"9001"
		year													"1986"
		observation_place_number			"1"
		observer_id										"8000"
		municipal_code								"LOHJA"
		nnn_coordinate								"667"
		eee_coordinate								"333"
		biotope_class									"3"
		route_representative_class		"1"
		spot_observation_place_count	"18"
		roaming_observation_place_count "0"
		observation_place_name				"JUSOLANLAMPI"
		first_observation_date				"1986-05-11"
		second_observation_date				nil
		first_observation_hour				"7"
		first_observation_duration		"5"
		second_observation_hour		 	 	"0"
		second_observation_duration		"0"
		water_system_area							"2.0"
		place_area										"2.0"
		area_covers_fully							"1"
		covering_area_beginning				nil
		covering_area_end							nil
		spot_counting									true
		binoculars										false
		boat													false
		gullbirds											true
		waders_eurasian_bittern				true
		passerine											true
	end

  factory :bird do
    abbr    "analpa"
    name    "sorsa"
  end

  factory :count do
    bird_id         "1"
    count           "0"
    observation_id  "1"
  end
end
