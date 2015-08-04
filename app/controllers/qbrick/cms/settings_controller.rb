module Qbrick
  module Cms
    class SettingsController < RailsSettingsUi::SettingsController
      helper RailsSettingsUi::SettingsHelper
      helper Qbrick::Cms::AdminHelper

      def update_all
        if @casted_settings[:errors].any?
          render :index
        else
          @casted_settings.map { |setting| RailsSettingsUi.settings_klass[setting[0]] = setting[1] if setting[0] != 'errors' }
          redirect_to qbrick.url_for(action: :index)
        end
      end

      private

      def setting_params
        params[:settings]
      end

      def cast_settings_params
        @casted_settings = RailsSettingsUi::TypeConverter.cast setting_params
      end
    end
  end
end
