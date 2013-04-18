class Count < ActiveRecord::Base
  attr_accessible :abbr, :count, :observation_id, :bird_attributes
  belongs_to :observation

  validate :tipuapi

  def tipuapi
    query_result = TipuApi::Interface.species filter = abbr
    species = query_result["species"]

    if species.is_a?(Array)
      species.each do |s|
        if s["id"].capitalize == abbr.capitalize
          return true
        end
      end
    elsif species.is_a?(Hash)
      if species["id"].capitalize == abbr.capitalize
        return true
      end
    end

    errors.add(:abbr, "Lajilyhenne ei kelpaa")
  end
end
