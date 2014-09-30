class AddRedirectUrlToQbrickPages < ActiveRecord::Migration
  def change
    I18n.available_locales.each do |locale|
      add_column :qbrick_pages, "redirect_url_#{locale.to_s.underscore}", :text
    end
  end
end
