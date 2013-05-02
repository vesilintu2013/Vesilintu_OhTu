require 'tipuapi'
class Observation < ActiveRecord::Base
  include TipuApi

  has_many :counts
  belongs_to :route
  belongs_to :place
  attr_accessible :year, :observer_id, :first_observation_date, :second_observation_date, :first_observation_hour, :first_observation_duration, :second_observation_hour, :second_observation_duration, :spot_counting, :binoculars, :boat, :gullbirds, :waders_eurasian_bittern, :passerine, :updated_at, :source, :route_attributes, :place_attributes, :counts_attributes, :place_id, :rktl_telescope
  accepts_nested_attributes_for :route, :place, :counts

  validates :year, :numericality => { :greater_than_or_equal_to => 1986, :less_than_or_equal_to => 2013 }, :if => "source == 'museum'"

  validates :observer_id, :presence => true, :if => "source == 'museum'"
  validates :first_observation_hour, :numericality => { :only_integer => true },
                                     :inclusion => 0..23,
                                     :allow_blank => true,
                                     :allow_nil => true, :if => "source == 'museum'"
  validates :second_observation_hour, :numericality => { :only_integer => true },
                                      :inclusion => 0..23,
                                      :allow_blank => true,
                                      :allow_nil => true, :if => "source == 'museum'"
  validates :first_observation_duration, :numericality => { :only_integer => true },
                                         :inclusion => 0..999,
                                         :allow_blank => true,
                                         :allow_nil => true, :if => "source == 'museum'"
  validates :second_observation_duration, :numericality => { :only_integer => true },
                                          :inclusion => 0..999,
                                          :allow_blank => true,
                                          :allow_nil => true, :if => "source == 'museum'"
  validate :tipu_observer, :if => "source == 'museum'"

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
    return result, search_params_hash(search)
  end

  def tipu_observer
    query_result = TipuApi::Interface.ringers filter = observer_id.to_s
    ringers = query_result["ringer"]

    # query_result["ringer"] is an Array of hashes if there are multiple results.
    if ringers.is_a?(Array)
      ringers.each do |ringer|
        if ringer["id"] == observer_id
          return true
        end
      end
    elsif ringers.is_a?(Hash)
      if ringers["id"] == observer_id
        return true
      end
    end

    # Check for observer-synonyms if observer_id is not found in TipuApi ringers
    query_result = TipuApi::Interface.observer_synonyms filter = observer_id.to_s
    synonyms = query_result["synonym"]

    if synonyms.is_a?(Array)
      synonyms.each do |synonym|
        if synonym["id"] == observer_id
          return true
        end
      end
    elsif synonyms.is_a?(Hash)
      if synonyms["id"] == observer_id
        return true
      end
    end

    errors.add(:observer_id, "Havainnoijatunnus ei kelpaa") 
  end

  def self.to_csv params
    places = []
    routes = []
    counts = []
    observations = search(params).first
    observations.each do |obs|
      places << obs.place unless obs.place.nil?
      routes << obs.route unless obs.route.nil?
      obs.counts.each{|c| counts << c}
    end

    [places, routes, counts, observations].map{|a| generate_csv(a)}
    
  end

  private

  def self.generate_csv array
    return nil if array.nil? || array.empty?
    array.uniq!
    CSV.generate do |csv|
      csv << array.first.class.column_names
      array.each do |s|
        csv << s.attributes.values_at(*array.first.class.column_names)
      end
    end
  end

  def self.search_params_hash(search)
    params = {}
    params[:observation_place_number] = search['observation_place_number'] unless
              search['observation_place_number'].blank?
    params[:year] = search['year'] unless
              search['year'].blank?
    params[:observer_id] = search['observer_id'] unless
              search['observer_id'].blank?
    params[:route_number] = search['route_number'] unless
              search['route_number'].blank?
    params[:source] = search['source'] unless
              search['source'].blank?
    params[:observation_place_name] = search['observation_place_name'] unless
              search['observation_place_name'].blank?
    params
  end
end
