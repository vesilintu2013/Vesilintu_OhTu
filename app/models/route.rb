class Route < ActiveRecord::Base
  attr_accessible :route_number, :year, :municipal_code, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :water_system_area
  has_many :observations
  has_many :places
  
  validates :route_number, :presence => true
  validates :year, :numericality => { :greater_than_or_equal_to => 1986, :less_than_or_equal_to => 2013 }
  validates :municipal_code, :presence => true, :length => { :minimum => 1, :maximum => 6 }
  validates :water_system_area, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 },
                                :allow_blank => true,
                                :allow_nil => true
end
