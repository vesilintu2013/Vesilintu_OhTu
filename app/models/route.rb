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
  validates :route_representative_class, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 3 },
                                         :allow_blank => true,
                                         :allow_nil => true
  validate :tipuapi_municipality

  def tipuapi_municipality
    query_result = TipuApi::Interface.municipalities filter = municipal_code
    municipalities = query_result["municipality"]

    if municipalities.is_a?(Array)
      municipalities.each do |m|
        if m["id"].capitalize == municipal_code.capitalize
          return true
        end
      end
    elsif municipalities.is_a?(Hash)
      if municipalities["id"].capitalize == municipal_code.capitalize
        return true
      end
    end

    errors.add(:municipal_code, "Kuntakoodi ei kelpaa")
  end
end
