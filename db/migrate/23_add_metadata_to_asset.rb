class AddMetadataToAsset < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :content_type, :string
    add_column :qbrick_bricks, :file_size, :string
  end
end
