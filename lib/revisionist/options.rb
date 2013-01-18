module Revisionist
  module Options

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods

      def prepare_options options
        options.symbolize_keys!

        class_attribute :revisionist_options

        self.revisionist_options = options.dup
        [:ignore, :skip, :only, :include, :meta].each do |k|
          revisionist_options[k] = Array(options[k]).map(&:to_sym)
        end

        self.revisionist_options
      end

    end
  end
end
