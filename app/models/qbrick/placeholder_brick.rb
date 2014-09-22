require_relative './brick'

module Qbrick
  class PlaceholderBrick < Brick
    PARTIAL_PATH = '/app/views/qbrick/placeholder_bricks/partials/_*.haml'

    def self.available_partials
      @partials ||= Qbrick::PartialExtractor.new.partials(PARTIAL_PATH)
    end

    def user_can_add_childs?
      false
    end

    def partial_name
      "qbrick/placeholder_bricks/partials/#{template_name}"
    end

    def cache_key
      super + partial_digest(partial_name)
    end
  end
end
