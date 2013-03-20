class Route < ActiveRecord::Base
  has_many :observations
  has_many :places
  attr_accessible :route_number, :year, :municipal_code, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :water_system_area
end
