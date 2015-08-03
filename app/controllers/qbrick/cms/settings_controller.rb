module Qbrick
  module Cms
    class SettingsController < BackendController
      def index
        fetch_settings
      end

      def update
        setting = Qbrick::Settings.find(params[:id].to_i)
        if setting.update(value: params[:settings][:value])
          redirect_to action: :index
        else
          fetch_settings
          render action: :index
        end
      end

      private

      def fetch_settings
        @settings = Qbrick::Settings.hierarchy
      end
    end
  end
end
