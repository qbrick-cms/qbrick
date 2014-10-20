class CreateSettingsCollections < ActiveRecord::Migration
  def self.up
    create_table :qbrick_settings_collections do |t|
      t.string :collection_type
    end
  end
 
  def self.down
    drop_table :qbrick_settings_collections
  end
end
