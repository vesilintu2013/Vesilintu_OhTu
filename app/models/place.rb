class Place < ActiveRecord::Base
  has_many :observations
  belongs_to :place
  attr_accessible :rktl_munincipal_code, :source, :observation_place_number, :nnn_coordinate, :eee_coordinate, :biotope_class, :observation_place_name, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end
end
