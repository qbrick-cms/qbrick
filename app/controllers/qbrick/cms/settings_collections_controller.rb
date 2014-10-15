module Qbrick
  module Cms
    class SettingsCollectionsController < AdminController

      def edit
        @settings_collection = Qbrick::SettingsCollection.find(params[:id])
      end

      def update
        @settings_collection = Qbrick::SettingsCollection.find(params[:id])
        @settings_collection.update_attributes(settings_collection_params)

        respond_with @settings_collection, location: edit_cms_settings_collection_path
      end

      private

      def settings_collection_params
        params.require(:settings_collection).permit(settings_attributes: [:value, :id])
      end
    end
  end
end
