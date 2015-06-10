module Qbrick
  class PagesController < ::ApplicationController
    respond_to :html
    before_action :set_locale
    before_action :find_page_by_path, only: :show

    def index
      @search = params[:search]
      return if @search.blank?

      @pages = Qbrick::Page.unscoped.published.content_page.search(@search)
    end

    def show
      if redirect_page?
        session[:qbrick_referrer] = @page.id
        redirect_to @page.redirect_url
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

    def set_locale
      new_locale = params[:locale] || session['frontend_locale'] || I18n.locale

      return I18n.locale if I18n.locale == new_locale || !I18n.locale_available?(new_locale)

      session['frontend_locale'] = new_locale.to_s
      I18n.locale = new_locale
    end
    alias frontend_locale set_locale

    def redirect_page?
      @page.present? && @page.redirect? && @page.redirect_url.present?
    end

    def find_page_by_path
      @page = Qbrick::Page.published.find_by_path params[:url].to_s
    end
  end
end
