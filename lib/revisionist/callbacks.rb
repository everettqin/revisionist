module Revisionist
  # TODO: Adapterize to support multi-orm
  module Callbacks

    def self.included base
      base.class_eval do
        extend ClassMethods
        include InstanceMethods

        after_create   :revision_on_create
        before_destroy :revision_on_destroy
        before_update  :revision_on_update
      end
    end

    module ClassMethods
      def set_associated_callbacks!

        revisionist_options[:include].each do |assoc_name|
          reflection = reflect_on_association(assoc_name.to_sym)

          # add callback options to this association for collection associations
          if reflection.collection?
            send reflection.macro,
               assoc_name,
               reflection.options.merge(after_add:    :revision_on_update,
                                        after_remove: :revision_on_update)
          end

        end
      end

    end

    module InstanceMethods
      private

      def revision_on_create
        revision_on :create
      end

      def revision_on_update assoc=nil
        # prevent extra revisions for has_many through
        return false if assoc and assoc.new_record?
        revision_on :update
      end

      def revision_on_destroy
        revision_on :destroy
      end

      def revision_on action
        # TODO: Add support for change owner (whodunnit)
        if revision_me?
          revisions.create(action: action, object: serialized_object)
        end
      end

    end

  end
end
