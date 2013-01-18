module Revisionist
  module Associations

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods

        alias_method_chain :serialized_object, :associations

        class << self
          alias_method_chain :prepare_options, :associations
          alias_method_chain :serialization_options, :associations
        end
      end
    end

    module ClassMethods
      # After the original +prepare_options+ method cleans the given options, this
      # alias also performs model related tasks on the <tt>:include</tt> option.
      #
      def prepare_options_with_associations options
        result = prepare_options_without_associations(options)

        result[:include].each do |assoc_name|
          accepts_nested_attributes_for assoc_name.to_sym
          attr_accessible  "#{assoc_name}_attributes"
        end

        result
      end

      def serialization_options_with_associations
        result = serialization_options_without_associations
        result[:include] = Hash[
          revisionist_options[:include].map{ |assoc_name|
            # exclude foreign key from json
            key = reflect_on_association(assoc_name).foreign_key.to_sym
            # TODO: support skipped fields in associations
            [assoc_name.to_s, {except: DEFAULT_SKIP + [key]}]
          }
        ]
        result
      end
    end

    module InstanceMethods
      def serialized_object_with_associations
        result = serialized_object_without_associations
        # rename association fields
        self.class.revisionist_options[:include].each do |assoc_name|
          if result[assoc_name.to_s]
            result["#{assoc_name}_attributes"] = result.delete(assoc_name.to_s)
          end
        end
        result
      end
    end

  end
end
