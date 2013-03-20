class Place < ActiveRecord::Base
  attr_accessible :observation_place_number, :nnn_coordinate, :eee_coordinate, :biotope_class, :observation_place_name, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end
  has_many :observations
  belongs_to :place
end
