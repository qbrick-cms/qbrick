class AddIdentifierToQbrickPages < ActiveRecord::Migration
  def change
    add_column :qbrick_pages, :identifier, :string
    add_index :qbrick_pages, :identifier, unique: true
  end
end
