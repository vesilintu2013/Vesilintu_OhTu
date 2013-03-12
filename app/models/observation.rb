class Observation < ActiveRecord::Base
  has_many :counts
  attr_accessible :route_number, :year, :observation_place_number, :observer_id, :municipal_code, :nnn_coordinate, :eee_coordinate, :biotope_class, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :observation_place_name, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :water_system_area, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source

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
