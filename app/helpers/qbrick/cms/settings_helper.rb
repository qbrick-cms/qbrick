# FIXME: this file is currently ignored by rubocop and could use some cleaning up
module Qbrick
  module Cms
    module SettingsHelper
      def render_setting_hash(settings, key = nil)
        path = settings.delete '_path'
        setting = settings.delete '_value'

        if settings.any? || setting.present?
          haml_tag :h3, t("settings.#{path}")
          haml_tag :hr
        end
        render_setting key, setting, path if setting.present?

        settings.each_pair do |subkey, subsettings|
          render_setting_hash subsettings, subkey
        end
      end

      def render_setting(key, setting, path)
        options = { locals: { key: (key.blank? ? path.to_s.split('').last : key), setting: setting, path: path } }
        render options.merge(partial: setting.partial_name)

      rescue => _e
        render options.merge(partial: 'form')
      end
    end
  end
end
