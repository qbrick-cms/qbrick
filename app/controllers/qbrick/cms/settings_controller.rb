module Qbrick
  module Cms
    class SettingsController < AdminController

      def edit
        @settings = Qbrick::Setting.all
      end

      def update
        @setting = Qbrick::Setting.find(params[:id])
        @setting.update_attributes(setting_params)

        respond_with @setting, location: edit_cms_settings_path
      end

      private

      def setting_params
        params.require(:setting).permit(:value)
      end
    end
  end
end
