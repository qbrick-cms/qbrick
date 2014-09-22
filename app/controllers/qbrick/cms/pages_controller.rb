require 'qbrick/page_tree'

module Qbrick
  module Cms
    class PagesController < AdminController
      def index
        @pages = Qbrick::Page.roots
        respond_with @pages
      end

      def show
        @page = Qbrick::Page.find(params[:id])
        respond_with @page
      end

      def new
        @page = Qbrick::Page.new
        @page.published ||= Qbrick::PublishState::UNPUBLISHED
        respond_with @page
      end

      def create
        @page = Qbrick::Page.create(page_params)

        if @page.valid?
          flash[:success] = t('layouts.qbrick.cms.flash.success', subject: Qbrick::Page.model_name.human)
          respond_with @page, location: qbrick.edit_cms_page_path(@page)
        else
          render 'new'
        end
      end

      def edit
        @page = Qbrick::Page.find(params[:id])
        @page.published ||= Qbrick::PublishState::UNPUBLISHED
        @page.bricks.each { |brick| brick.valid? }
        respond_with @page
      end

      def update
        @page = Qbrick::Page.find(params[:id])
        if @page.update_attributes(page_params)
          flash[:success] = t('layouts.qbrick.cms.flash.success', subject: Qbrick::Page.model_name.human)
          respond_with @page, location: qbrick.edit_cms_page_path(@page)
        else
          render 'edit'
        end
      end

      def destroy
        @page = Qbrick::Page.find(params[:id])
        @page.destroy
        redirect_to qbrick.cms_pages_path
      end

      def sort
        Qbrick::PageTree.update(params[:page_tree])
      end

      def mirror
        @page = Qbrick::Page.find(params[:page_id])

        unless @page.bricks.empty?
          if params[:rutheless] == 'true' || @page.bricks.unscoped.where(locale: params[:target_locale]).empty?
            @page.clear_bricks_for_locale(params[:target_locale])
            params[:failed_bricks] = @page.clone_bricks_to(params[:target_locale])
            params[:rutheless] = 'true'
          end
        end

        respond_to :js, :html
      end

      private

      def page_params
        safe_params = [
          :title, :page_title, :slug, :redirect_url, :url, :page_type, :parent_id,
          :keywords, :description, :published, :position, :google_verification_key
        ]
        params.require(:page).permit(*safe_params)
      end
    end
  end
end
