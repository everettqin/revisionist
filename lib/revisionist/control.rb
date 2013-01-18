module Revisionist
  module Control
    def self.included base
      base.extend         ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods

      def unnotable_fields
        DEFAULT_SKIP + revisionist_options[:skip] + revisionist_options[:ignore]
      end

    end

    module InstanceMethods

      # TODO: add methods to skip/merge revisions
      def revision_me?
        changed? && ! new_record?
      end

      def changed?
        revisions.empty? || notably_changed?
      end

      def notably_changed?
        ! revisions.last.object.diff(serialized_object).select do |k,v|
          ! self.class.unnotable_fields.include?(k.to_sym)
        end.blank?
      end

    end
  end
end
