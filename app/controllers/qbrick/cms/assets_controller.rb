module Qbrick
  module Cms
    class AssetsController < BackendController
      def index
        @assets = Qbrick::Asset.by_date
        respond_with @assets
      end

      def new
        @asset = Qbrick::Asset.new
        respond_with @asset
      end

      def create
        @asset = Qbrick::Asset.create params[:qbrick_asset]
        @asset.save
        respond_with @asset, location: cms_assets_path
      end

      def edit
        @asset = Qbrick::Asset.find(params[:id])
        respond_with @asset
      end

      def update
        @asset = Qbrick::Asset.find(params[:id])
        @asset.update_attributes(params[:qbrick_asset])
        respond_with @asset, location: cms_assets_path
      end

      def destroy
        @asset = Qbrick::Asset.find(params[:id])
        @asset.destroy
        redirect_to cms_assets_path
      end
    end
  end
end
