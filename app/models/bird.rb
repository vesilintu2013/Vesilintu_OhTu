class Bird < ActiveRecord::Base
  attr_accessible :abbr, :name
  has_many :counts
end
