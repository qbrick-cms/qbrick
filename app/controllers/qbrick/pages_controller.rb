module Qbrick
  class PagesController < ::ApplicationController
    respond_to :html
    before_action :find_page_by_url, only: :show

    def index
      @search = params[:search]
      return if @search.blank?
      @pages = Qbrick::Page.unscoped.published.content_page.search(@search)
    end

    def show
      if redirect_page?
        redirect_url = @page.redirect_url.sub(%r{\A\/+}, '') # remove all preceding slashes
        session[:qbrick_referrer] = @page.id
        redirect_to "/#{redirect_url}"
      elsif @page.present?
        respond_with @page
      elsif @page.blank? && respond_to?(:handle_404)
        handle_404
      else
        raise ActionController::RoutingError, 'Not Found'
      end
    end

    def lookup_by_id
      @page = Page.find(params[:id])
      redirect_to "/#{@page.url}"
    end

    private

    def redirect_page?
      @page.present? && @page.redirect? && @page.redirect_url.present?
    end

    def find_page_by_url
      url = locale.to_s
      url += "/#{params[:url]}" if params[:url].present?
      @page = Qbrick::Page.published.find_by_url(url)
    end
  end
end
