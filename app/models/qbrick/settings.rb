require 'rails-settings-cached'
RailsSettings::Settings.table_name = 'qbrick_settings'

module Qbrick
  class Settings < ::RailsSettings::CachedSettings
  end
end
