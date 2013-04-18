class Place < ActiveRecord::Base
  has_many :observations
  belongs_to :place
  attr_accessible :rktl_munincipal_code, :source, :observation_place_number, :nnn_coordinate, :eee_coordinate, :biotope_class, :observation_place_name, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :rktl_pog_society_id, :rktl_town, :rktl_map_number, :rktl_shore_length, :rktl_pog_zone_id, :rktl_project, :rktl_place_not_counted, :rktl_other, :rktl_zip, :rktl_it, :rktl_map_name

  validates :observation_place_number, :inclusion => 1..999, :if => "source == 'museum'"
  validates :nnn_coordinate, :presence => true, :if => "source == 'museum'"
  validates :eee_coordinate, :presence => true, :if => "source == 'museum'"
  validates :observation_place_name, :presence => true, :if => "source == 'museum'"
  validates :place_area, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 },
                         :allow_nil => true,
                         :allow_blank => true, :if => "source == 'museum'"
  validates :area_covers_fully, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2 },
                                :allow_nil => true,
                                :allow_blank => true, :if => "source == 'museum'"
end
