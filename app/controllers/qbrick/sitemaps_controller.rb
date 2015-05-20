module Qbrick
  class SitemapsController < ::ApplicationController
    def index
      last_page = Qbrick::Page.published.last
      return unless stale?(etag: last_page, last_modified: last_page.updated_at.utc)

      respond_to do |format|
        format.html
        format.xml { @pages = Qbrick::Page.published }
      end
    end
  end
end
