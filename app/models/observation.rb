class Observation < ActiveRecord::Base
  has_many :counts
  attr_accessible :route_number, :year, :observation_place_number, :observer_id, :municipal_code, :nnn_coordinate, :eee_coordinate, :biotope_class, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :observation_place_name, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :water_system_area, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source

  #
  # Local validations for the museum data. Based on migrations.
  # Commented out lines are either fine as is or need remote validations from
  # Tipu-API.
  #
  
  #validates :route_number # Validate in Tipu-API
  validates :year, :numericality => { :greater_than_or_equal_to => 1986, :less_than_or_equal_to => 2013 }
  validates :observation_place_number, :inclusion => 1..999
  #validates :observer_id # Validate in Tipu-API
  validates :municipal_code, :limit => 6
  validates :nnn_coordinate, :length => 3
  validates :eee_coordinate, :length => 3
  validates :biotope_class, :inclusion => 1..8 #1-8
  validates :route_representative_class, :inclusion 0..3 #0-3
  #validates :spot_observation_place_count # <= Number of known places, from Tipu-API
  #validates :roaming_ob  servation_place_count # <= Number of known places, from Tipu-API
  validates :observation_place_name, :with => /[a-zA-ZåäöÅÄÖ]/ # Any combination of lowercase and uppercase letters, including 'åäö'
  #validates :first_observation_date # Should be OK
  #validates :second_observation_date # Should be OK
  validates :first_observation_hour, :inclusion => 0..23
  validates :first_observation_duration, :inclusion => 1..999
  validates :second_observation_hour, :inclusion => 0..23
  validates :second_observation_duration, :inclusion => 1..999
  # TODO: Validations for water_system_area and place_area should allow null
  validates :water_system_area :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 } 
  validates :place_area :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 }
  validates :area_covers_fully, :inclusion => 0..2
  #validates :covering_area_beginning
  #validates :covering_area_end
  #validates :spot_counting
  #validates t.boolean :binoculars
  #validates t.boolean :boat
  #TODO: The following counts should be checked with a single validation
  validates :anapla, :numericality => { :greater_than_or_equal_to => 0 }
  validates :anacre :numericality => { :greater_than_or_equal_to => 0 }
  validates :anaacu :numericality => { :greater_than_or_equal_to => 0 }
  validates :anacly :numericality => { :greater_than_or_equal_to => 0 }
  validates :aytfer :numericality => { :greater_than_or_equal_to => 0 }
  validates :buccla :numericality => { :greater_than_or_equal_to => 0 }
  validates :mermer :numericality => { :greater_than_or_equal_to => 0 }
  validates :fulatr :numericality => { :greater_than_or_equal_to => 0 }
  validates :gavarc :numericality => { :greater_than_or_equal_to => 0 }
  validates :podcri :numericality => { :greater_than_or_equal_to => 0 }
  validates :podgri :numericality => { :greater_than_or_equal_to => 0 }
  validates :podaur :numericality => { :greater_than_or_equal_to => 0 }
  validates :cygcyg :numericality => { :greater_than_or_equal_to => 0 }
  validates :ansfab :numericality => { :greater_than_or_equal_to => 0 }
  validates :bracan :numericality => { :greater_than_or_equal_to => 0 }
  validates :anapen :numericality => { :greater_than_or_equal_to => 0 }
  validates :anaque :numericality => { :greater_than_or_equal_to => 0 }
  validates :aytful :numericality => { :greater_than_or_equal_to => 0 }
  validates :melfus :numericality => { :greater_than_or_equal_to => 0 }
  validates :merser :numericality => { :greater_than_or_equal_to => 0 }
  validates :meralb :numericality => { :greater_than_or_equal_to => 0 }
  #validates :gullbirds
  validates :larmin :numericality => { :greater_than_or_equal_to => 0 }
  validates :larrid :numericality => { :greater_than_or_equal_to => 0 }
  validates :larcan :numericality => { :greater_than_or_equal_to => 0 }
  validates :stehir :numericality => { :greater_than_or_equal_to => 0 }
  #validates :waders_eurasian_bittern 
  validates :galgal :numericality => { :greater_than_or_equal_to => 0 }
  validates :trigla :numericality => { :greater_than_or_equal_to => 0 }
  validates :trineb :numericality => { :greater_than_or_equal_to => 0 }
  validates :trioch :numericality => { :greater_than_or_equal_to => 0 }
  validates :acthyp :numericality => { :greater_than_or_equal_to => 0 }
  validates :numarq :numericality => { :greater_than_or_equal_to => 0 }
  validates :vanvan :numericality => { :greater_than_or_equal_to => 0 }
  validates :botste :numericality => { :greater_than_or_equal_to => 0 }
  #validates :passerine 
  validates :embsch :numericality => { :greater_than_or_equal_to => 0 }
  validates :acrsch :numericality => { :greater_than_or_equal_to => 0 }
  #validates t.timestamps
  
  # End of validations
  
  # Receive a hash of parameters and construct a query using the search terms 
  # in the hash.
  def self.search(search)
    results = Observation.scoped
    results = results.where(:route_number => search['route_number']) unless 
              search['route_number'].blank?
    results = results.where(:year => search['year']) unless
              search['year'].blank?
    results = results.where(:observation_place_number => search['observation_place_number']) unless
              search['observation_place_number'].blank?
    results = results.where(:observer_id => search['observer_id']) unless
              search['observer_id'].blank?
    results = results.where("lower(observation_place_name) = lower(?)", search['observation_place_name']) unless
              search['observation_place_name'].blank?
    return results
  end
end
