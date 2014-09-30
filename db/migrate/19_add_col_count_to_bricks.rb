class AddColCountToBricks < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :col_count, :integer, default: 0
  end
end
