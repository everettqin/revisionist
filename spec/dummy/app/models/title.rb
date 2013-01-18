class Title < ActiveRecord::Base
  attr_accessible :name

  belongs_to :person

  has_revisions include: :person
end
