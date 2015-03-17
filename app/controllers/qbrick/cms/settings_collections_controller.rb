module Qbrick
  module Cms
    class SettingsCollectionsController < BackendController
      def index
        @settings_collections = [
          Qbrick::SettingsCollection.find_by(collection_type: 'site'),
          Qbrick::SettingsCollection.find_by(collection_type: 'page'),
          Qbrick::SettingsCollection.find_by(collection_type: 'global')
        ]
      end

      def update
        @settings_collection = Qbrick::SettingsCollection.find(params[:id])
        @settings_collection.update_attributes(settings_collection_params)

        respond_with @settings_collection, location: cms_settings_collections_path
      end

      private

      def settings_collection_params
        params.require(:settings_collection).permit(settings_attributes: [:value, :id])
      end
    end
  end
end
