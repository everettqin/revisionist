module Revisionist
  module Serialization

    def self.included base
      base.extend         ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods

      def serialization_options
        { except: skipped_fields }
      end

      def skipped_fields
        DEFAULT_SKIP + revisionist_options[:skip]
      end

    end

    module InstanceMethods

      # TODO: Adapterize to support multi-orm
      def serialized_object
        as_json(self.class.serialization_options).merge inheritance_attributes
      end

      private

      def inheritance_attributes
        column = self.class.inheritance_column
        type   = read_attribute(column)
        if type.blank?
          {}
        else
          {column => type}
        end
      end

    end

  end
end
