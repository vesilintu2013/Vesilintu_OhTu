class Place < ActiveRecord::Base
  attr_accessible :observation_place_number, :nnn_coordinate, :eee_coordinate, :biotope_class, :observation_place_name, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end
  has_many :observations
  belongs_to :place

  validates :observation_place_number, :inclusion => 1..999
  validates :nnn_coordinate, :presence => true
  validates :eee_coordinate, :presence => true
  validates :observation_place_name, :presence => true
  validates :place_area, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 },
                         :allow_nil => true,
                         :allow_blank => true
  validates :area_covers_fully, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2 }
end
