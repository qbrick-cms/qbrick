class SetPageTypeToContentForEmptyFields < ActiveRecord::Migration
  def change
    Qbrick::Page.where( "page_type is NULL or page_type = ''" ).each do |page|
      page.update_attribute(:page_type, Qbrick::PageType::CONTENT)
    end
  end
end
