DATA_FIELDS = [
  {
  :name => :route_number,
  :width => 4,
  :type => :integer
  },
  {
  :name => :year,
  :width => 4,
  :type => :integer
  },
  {
  :name => :observation_place_number,
  :width => 2,
  :type => :integer
  },
  {
  :name => :observer_id,
  :width => 4,
  :type => :integer
  },
  {
  :name => :municipal_code,
  :width => 6,
  :type => :string
  },
  {
  :name => :NNN_coordinate,
  :width => 3,
  :type => :integer
  },
  {
  :name => :EEE_coordinate,
  :width => 2,
  :type => :integer
  },
  {
  :name => :biotope_class,
  :width => 1,
  :type => :integer
  },
  {
  :name => :route_representative_class,
  :width => 1,
  :type => :integer
  },
  {
  :name => :spot_observation_place_count,
  :width => 2,
  :type => :integer
  },
  {
  :name => :roaming_observation_place_count,
  :width => 2,
  :type => :integer
  },
  {
  :name => :observation_place_name,
  :width => 17,
  :type => :string
  },
  {
  :name => :first_observation_date_day,
  :width => 2,
  :type => :integer
  },
  {
  :name => :first_observation_date_month,
  :width => 1,
  :type => :integer
  },
  {
  :name => :first_observation_time_hour,
  :width => 2,
  :type => :integer
  },
  {
  :name => :first_observation_length_minutes,
  :width => 3,
  :type => :integer
  },
  {
  :name => :second_observation_date_day,
  :width => 2,
  :type => :integer
  },
  {
  :name => :second_observation_date_month,
  :width => 1,
  :type => :integer
  },
  {
  :name => :second_observation_time_hour,
  :width => 2,
  :type => :integer
  },
  {
  :name => :second_observation_length_minutes,
  :width => 3,
  :type => :integer
  },
  {
  :name => :water_system_area,
  :width => 6,
  :type => :integer
  },
  {
  :name => :place_counting_area,
  :width => 6,
  :type => :integer
  },
  {
  :name => :place_counting_area_covers_whole_water_system,
  :width => 1,
  :type => :integer
  },
  {
  :name => :places_which_cover_whole_water_system,
  :width => 5,
  :type => :string
  },
  {
  :name => :unknown,
  :width => 3,
  :type => :integer
  },
  {
  :name => :spot_counting,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :roaming_counting,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :binoculars,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :boat,
  :width => 1,
  :type => :boolean
  },

  {
  :name => :anapla,
  :width => 3,
  :type => :integer
  },
  {
  :name => :anacre,
  :width => 3,
  :type => :integer
  },
  {
  :name => :anaacu,
  :width => 3,
  :type => :integer
  },
  {
  :name => :aytfer,
  :width => 3,
  :type => :integer
  },
  {
  :name => :buccla,
  :width => 3,
  :type => :integer
  },
  {
  :name => :mermer,
  :width => 3,
  :type => :integer
  },
  {
  :name => :fulatr,
  :width => 3,
  :type => :integer
  },
  {
  :name => :gavarc,
  :width => 3,
  :type => :integer
  },
  {
  :name => :podcri,
  :width => 3,
  :type => :integer
  },
  {
  :name => :podgri,
  :width => 3,
  :type => :integer
  },
  {
  :name => :podaur,
  :width => 3,
  :type => :integer
  },
  {
  :name => :cygcyg,
  :width => 3,
  :type => :integer
  },
  {
  :name => :ansfab,
  :width => 3,
  :type => :integer
  },
  {
  :name => :bracan,
  :width => 3,
  :type => :integer
  },
  {
  :name => :anapen,
  :width => 3,
  :type => :integer
  },
  {
  :name => :anaque,
  :width => 3,
  :type => :integer
  },
  {
  :name => :aytful,
  :width => 3,
  :type => :integer
  },
  {
  :name => :melfus,
  :width => 3,
  :type => :integer
  },
  {
  :name => :merser,
  :width => 3,
  :type => :integer
  },
  {
  :name => :meralb,
  :width => 3,
  :type => :integer
  },
  {
  :name => :gullbirds,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :larmin,
  :width => 3,
  :type => :integer
  },
  {
  :name => :larrid,
  :width => 3,
  :type => :integer
  },
  {
  :name => :larcan,
  :width => 3,
  :type => :integer
  },
  {
  :name => :stehir,
  :width => 3,
  :type => :integer
  },
  {
  :name => :KAHLAAJAT_KAULUSHAIKARA,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :galgal,
  :width => 3,
  :type => :integer
  },
  {
  :name => :trigla,
  :width => 3,
  :type => :integer
  },
  {
  :name => :trineb,
  :width => 3,
  :type => :integer
  },
  {
  :name => :trioch,
  :width => 3,
  :type => :integer
  },
  {
  :name => :acthyp,
  :width => 3,
  :type => :integer
  },
  {
  :name => :numarq,
  :width => 3,
  :type => :integer
  },
  {
  :name => :vanvan,
  :width => 3,
  :type => :integer
  },
  {
  :name => :botste,
  :width => 3,
  :type => :integer
  },
  {
  :name => :VARPUSLINNUT,
  :width => 1,
  :type => :boolean
  },
  {
  :name => :embsch,
  :width => 3,
  :type => :integer
  },
  {
  :name => :acrsch,
  :width => 3,
  :type => :integer
  }
]

