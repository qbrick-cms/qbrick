require_relative '../../app/models/qbrick/placeholder_brick'

module Qbrick
  module TouchPlaceholders
    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        after_save :touch_placeholders
      end
    end

    def touch_placeholders
      return unless self.class.placeholder_templates.present?
      self.class.placeholder_templates.each do |template_name|
        related_templates = Qbrick::PlaceholderBrick.where(template_name: template_name)
        related_templates.each(&:touch) if related_templates
      end
    end

    module ClassMethods
      def placeholder_templates(*attributes)
        if attributes.empty?
          @shoestrap_placeholder_templates
        else
          @shoestrap_placeholder_templates = attributes
        end
      end
    end
  end
end
