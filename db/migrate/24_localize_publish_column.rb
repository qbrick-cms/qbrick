class LocalizePublishColumn < ActiveRecord::Migration
  def up
    rename_column :qbrick_pages, :published, :published_en
    add_column :qbrick_pages, :published_de, :integer, default: 0

    I18n.available_locales.each do |locale|
      column_name = :"published_#{locale.to_s.underscore}"
      add_column :qbrick_pages, column_name, :integer, default: 0 unless column_exists? :qbrick_pages, column_name
    end

    new_translations = Qbrick::Page.translated_columns_for(:published) - %w(published_en)
    new_translations << 'published_de' unless new_translations.include? 'published_de'

    Qbrick::Page.all.each do |page|
      page.update_columns Hash[new_translations.zip([page.published_en] * new_translations.count)]
    end
  end

  def down
    translated_columns = Qbrick::Page.translated_columns_for(:published) - %w(published_en)
    rename_column :qbrick_pages, :published_en

    translated_columns.each do |column|
      remove_column :qbrick_pages, column
    end
  end
end
