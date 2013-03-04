class Observation < ActiveRecord::Base
  has_many :additional_observations
  attr_accessible :route_number, :year, :observation_place_number, :observer_id, :municipal_code, :nnn_coordinate, :eee_coordinate, :biotope_class, :route_representative_class, :spot_observation_place_count, :roaming_observation_place_count, :observation_place_name, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :water_system_area, :place_area, :area_covers_fully, :covering_area_beginning, :covering_area_end, :spot_counting, :binoculars, :boat, :anapla, :anacre, :anaacu, :anacly, :aytfer, :buccla, :mermer, :fulatr, :gavarc, :podcri, :podgri, :podaur, :cygcyg, :ansfab, :bracan, :anapen, :anaque, :aytful, :melfus, :merser, :meralb, :gullbirds, :larmin, :larrid, :larcan, :stehir, :waders_eurasian_bittern, :galgal, :trigla, :trineb, :trioch, :acthyp, :numarq, :vanvan, :botste, :passerine, :embsch, :acrsch, :created_at, :updated_at

  def self.search(search_terms)
    query_terms = Hash.new
    query_terms[:route_number] = search_terms[:route_number].to_i unless search_terms[:route_number].blank?
    query_terms[:year] = search_terms[:year].to_i unless search_terms[:year].blank?
    query_terms[:observation_place_number] = search_terms[:observation_place_number].to_i unless search_terms[:observation_place_number].blank?
    query_terms[:observer_id] = search_terms[:observer_id].to_i unless search_terms[:observer_id].blank?

    return Observation.where(query_terms)
  end
end
