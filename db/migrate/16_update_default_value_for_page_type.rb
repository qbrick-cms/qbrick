class UpdateDefaultValueForPageType < ActiveRecord::Migration
  def up
    change_column :qbrick_pages, :page_type, :string, :default => Qbrick::PageType::CONTENT
  end

  def down
    change_column_default(:qbrick_pages, :page_type, nil)
  end
end
