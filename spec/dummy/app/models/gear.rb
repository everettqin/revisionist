class Gear < ActiveRecord::Base
  attr_accessible :name

  has_many :wotsits
end
