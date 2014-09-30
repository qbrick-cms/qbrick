class AddAdditionalFieldsToQbrickBricks < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :asset, :string
    add_column :qbrick_bricks, :open_in_new_window, :boolean
  end
end
