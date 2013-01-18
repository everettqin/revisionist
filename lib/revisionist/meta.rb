module Revisionist
  module Meta

    def self.included base
      base.class_eval do
        include InstanceMethods

        alias_method_chain :serialized_object, :meta
      end
    end

    module InstanceMethods

      def serialized_object_with_meta
        meta_hash = Hash[
          revisionist_options[:meta].map{ |m| [ m.to_s, send(m) ] }
        ]
        serialized_object_without_meta.reverse_merge(meta_hash)
      end

    end

  end
end
