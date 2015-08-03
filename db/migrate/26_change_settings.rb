class ChangeSettings < ActiveRecord::Migration
  def change
    remove_index :qbrick_settings, :key
    rename_column :qbrick_settings, :key, :var
    remove_column :qbrick_settings, :settings_collection_id

    change_table :qbrick_settings do |t|
      t.change :var, :string, null: false
      t.change :value, :text, null: false

      t.integer :thing_id, null: true
      t.string :thing_type, limit: 30, null: true
      t.timestamps
    end

    add_index :qbrick_settings, %i(thing_type thing_id var), unique: true
  end
end
