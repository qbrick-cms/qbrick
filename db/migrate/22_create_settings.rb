class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :qbrick_settings do |t|
      t.string :key
      t.text :value
    end
    
    add_index :qbrick_settings, :key, :unique => true
  end
 
  def self.down
    drop_table :qbrick_settings
  end
end
