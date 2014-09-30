class CreateQbrickBrickTypes < ActiveRecord::Migration

  def change
    create_table :qbrick_brick_types do |t|
      t.string :class_name
      t.string :group
      t.boolean :disabled
      t.timestamps
    end
  end

end
