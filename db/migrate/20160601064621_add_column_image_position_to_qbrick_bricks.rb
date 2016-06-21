class AddColumnImagePositionToQbrickBricks < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :image_position, :string
  end
end
