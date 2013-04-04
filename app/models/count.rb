class Count < ActiveRecord::Base
  attr_accessible :abbr, :count, :observation_id, :bird_attributes
  belongs_to :observation
end
