require 'tipuapi'
class Place < ActiveRecord::Base
  include TipuApi

  has_many :observations
  belongs_to :place
  attr_accessible :rktl_munincipal_code, :source, :observation_place_number, :nnn_coordinate, :eee_coordinate, :biotope_class, :observation_place_name, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :rktl_pog_society_id, :rktl_town, :rktl_map_number, :rktl_shore_length, :rktl_pog_zone_id, :rktl_project, :rktl_place_not_counted, :rktl_other, :rktl_zip, :rktl_it, :rktl_map_name

  # Common validations for museum and rktl data
  validates :place_area, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 9999.9 },
                         :allow_nil => true,
                         :allow_blank => true
  validates :nnn_coordinate, :presence => true
  validates :eee_coordinate, :presence => true

  # Validations for museum data
  validates :observation_place_number, :inclusion => 1..999, :if => "source == 'museum'"
  validates :observation_place_name, :presence => true, :if => "source == 'museum'"
  validates :area_covers_fully, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2 },
                                :allow_nil => true,
                                :allow_blank => true, :if => "source == 'museum'"
  validates :biotope_class, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 8 },
                            :allow_nil => true,
                            :allow_blank => true, :if => "source == 'museum'"
  validate :tipuapi_coordinates, :if => "source == 'museum'"

  # Validations for rktl data
  validates :observation_place_number, :inclusion => 1..9999, :if => "source == 'rktl'"

  def tipuapi_coordinates
    route = Route.find(route_id)
    query_result = TipuApi::Interface.validate_coordinates municipality = route.municipal_code, lat = nnn_coordinate.to_s + "5000", lon = eee_coordinate.to_s + "5000"
    
    if query_result.is_a?(Hash)
      if query_result["validation-response"]["pass"] == true
        return true
      end
    end

    errors.add(:nnn_coordinate, "Koordinaatti ei osu annettuun kuntaan")
    errors.add(:eee_coordinate, "Koordinaatti ei osu annettuun kuntaan")
  end
end
