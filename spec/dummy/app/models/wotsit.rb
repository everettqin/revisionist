class Wotsit < ActiveRecord::Base
  attr_accessible :name

  belongs_to :widget
  belongs_to :gear
end
