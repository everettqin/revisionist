module Revisionist
  module Model

    def self.included base
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def has_revisions options={}

        include Options
        include Serialization
        include Associations
        include Control
        include Callbacks
        include Meta

        prepare_options options

        set_associated_callbacks!

        has_many :revisions, as: :target
      end
    end # ClassMethods

    # module InstanceMethods
    # end

  end # Model

end
