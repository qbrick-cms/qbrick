module Qbrick
  module Cms
    class SettingsController < BackendController
      def index
        fetch_settings
      end

      def create
        if Qbrick::Settings.create var: setting_params[:var], value: setting_params[:value]
          redirect_to action: :index
        else
          fetch_settings
          render action: :index
        end
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

      def setting_params
        permitted_params[:settings]
      end

      def permitted_params
        params.permit settings: %i(var value)
      end

      def fetch_settings
        @settings = Qbrick::Settings.all_object_hash.values
      end
    end
  end
end
