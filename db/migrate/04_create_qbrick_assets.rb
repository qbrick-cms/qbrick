class CreateQbrickAssets < ActiveRecord::Migration

  def change
    create_table :qbrick_assets do |t|
      t.string :file
      t.timestamps null: true
    end
  end

end
