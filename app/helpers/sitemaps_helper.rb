module SitemapsHelper
  def with_every_locale(page)
    I18n.available_locales.each do |locale|
      I18n.with_locale locale do
        yield "http://#{request.host_with_port}#{page.path_with_prefixed_locale}" if page.path.present? && page.published?
      end
    end
  end
end
