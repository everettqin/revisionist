class Revision < ActiveRecord::Base

  belongs_to :target, polymorphic: true

  validates_presence_of :action

  attr_accessible :target_type, :target_id, :action, :whodunnit, :object

  serialize :object

  delegate :revisionist_options, to: :model

  # Create a new instance with the revision attributes
  #
  # @example Get the revisioned instance from the serialized object
  #   revisions.reify
  #
  # @return [ Object ] revisioned model
  def reify
    model.new(object.select{|k,v| k != inheritance_column})
  end

  private

  # Return the model class of the revision target
  #
  # This method will also choose the inherited STI class if appropriate
  #
  # @return [ Class ] target class
  def model
    if object[inheritance_column]
      object[inheritance_column].constantize
    else
      original_class
    end
  end

  def inheritance_column
    original_class.inheritance_column
  end

  def original_class
    target_type.constantize
  end

end
