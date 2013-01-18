class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :title_attributes

  has_one :title

  belongs_to :company

  has_revisions meta:    :full_name,
                include: [:title, :company]

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Employee < Person
end

class Manager < Person
end
