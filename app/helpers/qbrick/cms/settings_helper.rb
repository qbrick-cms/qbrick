# FIXME: this file is currently ignored by rubocop and could use some cleaning up
module Qbrick
  module Cms
    module SettingsHelper
      def render_settings(settings)
        result = ''
        settings.sort { |a, b| t(a.var) <=> t(b.var) }.map do |setting|
          result << render_setting(setting)
        end
        result.html_safe
      end

      def render_setting(setting)
        options = { locals: { setting: setting } }
        render options.merge(partial: setting.partial_name)

      rescue => _e
        render options.merge(partial: 'form')
      end
    end
  end
end
