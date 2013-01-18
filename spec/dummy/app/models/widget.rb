class Widget < ActiveRecord::Base
  attr_accessible :name, :counter_field, :style

  has_many :fluxors
  has_many :wotsits
  has_and_belongs_to_many :cogs
  has_many :gears, through: :wotsits

  has_revisions include: [:fluxors, :wotsits, :cogs, :gears],
                skip:    :counter_field,
                ignore:  :style
end
