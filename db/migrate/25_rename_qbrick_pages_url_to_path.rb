class RenameQbrickPagesUrlToPath < ActiveRecord::Migration
  def up
    I18n.available_locales.each do |locale|
      rename_column :qbrick_pages, :"url_#{locale.to_s.underscore}", :"path_#{locale.to_s.underscore}"
    end

    pages = Qbrick::Page.unscoped.all

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        pages.each do |page|
          page.update_attribute :path, page.create_path
        end
      end
    end
  end

  def down
    I18n.available_locales.each do |locale|
      rename_column :qbrick_pages, :"path_#{locale.to_s.underscore}", :"url_#{locale.to_s.underscore}"
    end

    pages = Qbrick::Page.unscoped.all

    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        pages.each do |page|
          page.update_attribute :url, page.create_path
        end
      end
    end
  end
end
