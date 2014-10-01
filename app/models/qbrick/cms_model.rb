module Qbrick
  module CMSModel
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def index_attributes(*attributes)
        if attributes.empty?
          @shoestrap_index_attributes
        else
          @shoestrap_index_attributes = attributes
        end
      end

      def editable_attributes(*attributes)
        if attributes.empty?
          @shoestrap_editable_attributes
        else
          @shoestrap_editable_attributes = attributes
        end
      end
    end
  end
end
