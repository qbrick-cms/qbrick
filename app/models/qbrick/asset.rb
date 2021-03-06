module Qbrick
  class Asset < ActiveRecord::Base
    scope :by_date, -> { order('updated_at DESC') }
    mount_uploader :file, Qbrick::AssetUploader

    def file_type
      return unless file.path.present?

      ext = File.extname(file.path).split('.').last
      ext.to_sym if ext.present?
    end

    def name
      File.basename(file.path) if file.present? && file.path.present?
    end

    def path
      file.url
    end

    def path=(_val)
      # do nothing
    end

    def filename
      try(:file).try(:file).try(:filename)
    end
  end
end
