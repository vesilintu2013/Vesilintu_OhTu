class Route < ActiveRecord::Base
  attr_accessible :route_number, :year, :municipal_code, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :water_system_area
  has_many :observations
  has_many :places
end
