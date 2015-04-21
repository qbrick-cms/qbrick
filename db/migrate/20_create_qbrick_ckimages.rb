class CreateQbrickCkimages < ActiveRecord::Migration
  def change
    create_table :qbrick_ckimages do |t|
      t.string :file

      t.timestamps null: true
    end
  end
end
