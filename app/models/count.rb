class Count < ActiveRecord::Base
  attr_accessible :bird_id, :count, :observation_id
  belongs_to :observation
  belongs_to :bird
end
