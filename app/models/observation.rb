class Observation < ActiveRecord::Base
  has_many :counts
  belongs_to :route
  belongs_to :place
  attr_accessible :year, :observer_id, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source, :place_id

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
