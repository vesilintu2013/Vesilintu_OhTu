class Observation < ActiveRecord::Base
  has_many :counts
  attr_accessible :route_number, :year, :observation_place_number, :observer_id, :municipal_code, :nnn_coordinate, :eee_coordinate, :biotope_class, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :observation_place_name, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :water_system_area, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source

  SEARCH_TERMS = ['route_number', 'year', 'observation_place_number',
                  'observer_id']

  # Receive a hash of parameters, find out which ones are allowed search
  # parameters, and finally perform a query using the allowed terms.
  def self.search(search_terms)
    query_terms = Hash.new
    search_terms.each do |key, value|
      if SEARCH_TERMS.include?(key)
        query_terms[key] = value unless value.blank?
      end
    end

    Observation.where(query_terms)
  end
end
