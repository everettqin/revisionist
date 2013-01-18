class Fluxor < ActiveRecord::Base
  attr_accessible :name

  belongs_to :widget
end
