class Count < ActiveRecord::Base
  attr_accessible :bird_id, :count, :observation_id, :bird_attributes
  belongs_to :observation
  belongs_to :bird
  accepts_nested_attributes_for :bird
end
