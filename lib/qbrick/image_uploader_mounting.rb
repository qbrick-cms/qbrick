require 'carrierwave'
require 'active_support/concern'

module Qbrick
  module ImageUploaderMounting
    extend ActiveSupport::Concern

    included do
      extend CarrierWave::Mount

      mount_uploader :image, Qbrick::ImageBrickImageUploader

      after_save :resize_image_if_size_changed

      def resize_image_if_size_changed
        image.recreate_versions! if image_size_changed? && image_present?
      end

      delegate :present?, to: :image, prefix: true
    end
  end
end
