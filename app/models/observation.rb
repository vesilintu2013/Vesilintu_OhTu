require 'tipuapi'
class Observation < ActiveRecord::Base
  include TipuApi

  has_many :counts
  belongs_to :route
  belongs_to :place
  attr_accessible :year, :observer_id, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source, :route_attributes, :place_attributes, :counts_attributes, :place_id, :rktl_telescope
  accepts_nested_attributes_for :route, :place, :counts

  validates :year, :numericality => { :greater_than_or_equal_to => 1986, :less_than_or_equal_to => 2013 }
  validates :observer_id, :presence => true
  validates :first_observation_hour, :numericality => { :only_integer => true },
                                     :inclusion => 0..23,
                                     :allow_blank => true,
                                     :allow_nil => true
  validates :second_observation_hour, :numericality => { :only_integer => true },
                                      :inclusion => 0..23,
                                      :allow_blank => true,
                                      :allow_nil => true
  validates :first_observation_duration, :numericality => { :only_integer => true },
                                         :inclusion => 0..999,
                                         :allow_blank => true,
                                         :allow_nil => true
  validates :second_observation_duration, :numericality => { :only_integer => true },
                                          :inclusion => 0..999,
                                          :allow_blank => true,
                                          :allow_nil => true
  validate :tipu_observer

  # Receive a hash of parameters and construct a query using the search terms 
  # in the hash.
  def self.search(search)
    result = Observation.scoped(:include => [:place, :route])
    result = result.scoped(:conditions => { :places => { :observation_place_number => search['observation_place_number'] } } ) unless
              search['observation_place_number'].blank?
    result = result.scoped(:conditions => { :year => search['year'] }) unless
              search['year'].blank?
    result = result.scoped(:conditions => { :observer_id => search['observer_id'] }) unless
              search['observer_id'].blank?
    result = result.scoped(:conditions => { :routes => { :route_number => search['route_number'] } }) unless
              search['route_number'].blank?
    result = result.scoped(:conditions => { :source => search['source'] }) unless
              search['source'].blank?
    result = result.where("lower(places.observation_place_name) = lower(?)",  search['observation_place_name'] ) unless
              search['observation_place_name'].blank?
    return result
  end

  def tipu_observer
    query_result = TipuApi::Interface.ringers filter = observer_id.to_s
    query_result["ringer"].each do |ringer|
      if ringer["id"] == observer_id
        return true
      end
    end
    errors.add(:observer_id, "Havainnoijatunnus ei kelpaa") 
  end
end
