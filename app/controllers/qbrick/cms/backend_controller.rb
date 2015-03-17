module Qbrick
  module Cms
    class BackendController < ActionController::Base
      respond_to :html
      layout 'qbrick/cms/application'
      before_action :set_content_locale, :authenticate_admin!

      def set_content_locale
        return if params[:content_locale].blank?
        I18n.locale = params[:content_locale]
      end

      def default_url_options
        { content_locale: I18n.locale }.merge(super)
      end
    end
  end
end
