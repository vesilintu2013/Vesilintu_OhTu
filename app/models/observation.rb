class Observation < ActiveRecord::Base
  has_many :additional_observations
end
