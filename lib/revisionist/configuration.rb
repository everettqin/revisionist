module Revisionist
  module Configuration

    def configure
      yield Configuration
    end

    class << self
      def global_options
        @global_options ||= {}
      end

      def serializer= value
        if value
          global_options[:serializer] = value
        elsif value.nil?
          global_options.delete(:serializer)
        else
          raise ArgumentError, "FalseClass not viable serializer option"
        end
        # put the serializer into the default revision class
        Revision.serialize :object, value
      end

      def serializer
        global_options[:serializer]
      end

    end

  end
end
