# encoding: utf-8
require 'carrierwave/processing/mime_types'

module Qbrick
  class AssetBrickAssetUploader < CarrierWave::Uploader::Base
    include CarrierWave::MimeTypes
    storage :file

    process :set_content_type
    process :save_content_type_and_size_in_model

    def save_content_type_and_size_in_model
      model.content_type = file.content_type if file.content_type
      model.file_size = file.size
    end

    def store_dir
      model_identifier = model.class.name.underscore.gsub(/^qbrick/, 'cms')
      "uploads/#{model_identifier}/#{mounted_as}/#{model.id}"
    end

    def extension_white_list
      %w(pdf doc docx xls xlsx ppt pptx)
    end
  end
end
