module Qbrick
  class SettingsCollection < ActiveRecord::Base

    has_many :settings

    accepts_nested_attributes_for :settings

    # TODO: handle localized settings
    # TODO: Settings attached to page/etc

  end
end
