module Qbrick
  class SliderBrick < Brick
    include Qbrick::BrickList

    acts_as_brick_list

    def fulltext
    end

    def to_style_class
      [super, 'carousel', 'slide'].join(' ')
    end

    def allowed_brick_types
      %w(Qbrick::ImageBrick Qbrick::VideoBrick)
    end
  end
end
