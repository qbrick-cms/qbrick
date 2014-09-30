module Qbrick
  class ImageBrick < Brick
    include Qbrick::ImageUploaderMounting

    validates :image,
              :image_size, presence: true

    def collect_fulltext
      [super, caption].join(' ')
    end

    def user_can_add_childs?
      false
    end
  end
end
